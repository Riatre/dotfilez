import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { AssistantMessage } from "@earendil-works/pi-ai";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const CHARS_PER_TOKEN = 4; // rough heuristic for live estimate
const MIN_TPS_SECONDS = 2; // hide TPS until enough wall time has passed

function fmt(n: number): string {
	if (n < 1000) return n.toString();
	if (n < 10000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1000000) return `${Math.round(n / 1000)}k`;
	if (n < 10000000) return `${(n / 1000000).toFixed(1)}M`;
	return `${Math.round(n / 1000000)}M`;
}

function fmtCwd(cwd: string): string {
	const home = process.env.HOME || process.env.USERPROFILE;
	if (home && cwd.startsWith(home)) return `~${cwd.slice(home.length)}`;
	return cwd;
}

export default function (pi: ExtensionAPI) {
	let startMs = 0;
	let chars = 0;
	let liveTps = 0;
	let finalTpsText = "";
	let streaming = false;
	let elapsedAtEnd = 0;
	let timer: ReturnType<typeof setInterval> | null = null;
	let requestRender: (() => void) | null = null;

	const stopLive = () => {
		if (timer) {
			clearInterval(timer);
			timer = null;
		}
	};

	pi.on("message_start", async (event) => {
		if (event.message.role !== "assistant") return;
		startMs = performance.now();
		chars = 0;
		liveTps = 0;
		streaming = true;
		elapsedAtEnd = 0;
		stopLive();
		timer = setInterval(() => {
			const secs = (performance.now() - startMs) / 1000;
			liveTps = secs > 0 ? Math.round(chars / CHARS_PER_TOKEN / secs) : 0;
			requestRender?.();
		}, 300);
	});

	pi.on("message_update", async (event) => {
		const e = event.assistantMessageEvent;
		if (
			e?.type === "text_delta" ||
			e?.type === "thinking_delta" ||
			e?.type === "toolcall_delta"
		) {
			chars += e.delta.length;
		}
	});

	pi.on("message_end", async (event) => {
		stopLive();
		liveTps = 0;
		streaming = false;
		if (event.message.role !== "assistant") return;
		elapsedAtEnd = (performance.now() - startMs) / 1000;
		const tokens = event.message.usage?.output ?? 0;
		const tps = elapsedAtEnd > 0 ? Math.round(tokens / elapsedAtEnd) : 0;
		finalTpsText = `${tps} tok/s`;
		requestRender?.();
	});

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;

		ctx.ui.setFooter((tui, theme, footerData) => {
			requestRender = () => tui.requestRender();
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			const buildStatsLine = (width: number): string => {
				let input = 0,
					output = 0,
					cacheRead = 0,
					cacheWrite = 0,
					cost = 0;
				let latestHitRate: number | undefined;

				for (const e of ctx.sessionManager.getEntries()) {
					if (e.type === "message" && e.message.role === "assistant") {
						const m = e.message as AssistantMessage;
						input += m.usage.input;
						output += m.usage.output;
						cacheRead += m.usage.cacheRead;
						cacheWrite += m.usage.cacheWrite;
						cost += m.usage.cost.total;
						const prompt = m.usage.input + m.usage.cacheRead + m.usage.cacheWrite;
						latestHitRate = prompt > 0 ? (m.usage.cacheRead / prompt) * 100 : undefined;
					}
				}

				const usage = ctx.getContextUsage();
				const ctxWindow = usage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
				const ctxPercentValue = usage?.percent ?? 0;
				const ctxPercentStr = usage?.percent !== null ? `${ctxPercentValue.toFixed(1)}%` : "?";

				const parts: string[] = [];
				if (input) parts.push(theme.fg("dim", `↑${fmt(input)}`));
				if (output) parts.push(theme.fg("dim", `↓${fmt(output)}`));
				if (cacheRead) parts.push(theme.fg("dim", `R${fmt(cacheRead)}`));
				if (cacheWrite) parts.push(theme.fg("dim", `W${fmt(cacheWrite)}`));
				if ((cacheRead > 0 || cacheWrite > 0) && latestHitRate !== undefined) {
					parts.push(theme.fg("dim", `CH${latestHitRate.toFixed(1)}%`));
				}
				if (cost || (ctx.model && ctx.modelRegistry.isUsingOAuth(ctx.model))) {
					const sub = ctx.model && ctx.modelRegistry.isUsingOAuth(ctx.model) ? " (sub)" : "";
					parts.push(theme.fg("dim", `$${cost.toFixed(3)}${sub}`));
				}

				const ctxDisplay = `${ctxPercentStr}/${fmt(ctxWindow)}`;
				parts.push(
					ctxPercentValue > 90
						? theme.fg("error", ctxDisplay)
						: ctxPercentValue > 70
							? theme.fg("warning", ctxDisplay)
							: theme.fg("dim", ctxDisplay),
				);

				const elapsed = streaming ? (performance.now() - startMs) / 1000 : elapsedAtEnd;
				if (elapsed >= MIN_TPS_SECONDS && (liveTps > 0 || finalTpsText)) {
					const tps = streaming ? `${liveTps} tok/s` : finalTpsText;
					parts.push(theme.fg("accent", tps));
				}

				const left = parts.join(theme.fg("dim", " "));

				let right = ctx.model?.id || "no-model";
				if (footerData.getAvailableProviderCount() > 1 && ctx.model) {
					right = `(${ctx.model.provider}) ${right}`;
				}
				const rightStyled = theme.fg("dim", right);

				const leftW = visibleWidth(left);
				const rightW = visibleWidth(rightStyled);
				if (leftW + 2 + rightW <= width) {
					const pad = " ".repeat(width - leftW - rightW);
					return left + pad + rightStyled;
				}
				return truncateToWidth(left, width, theme.fg("dim", "..."));
			};

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const cwd = fmtCwd(ctx.sessionManager.getCwd());
					const branch = footerData.getGitBranch();
					const sessionName = ctx.sessionManager.getSessionName();
					let pwd = cwd;
					if (branch) pwd += ` (${branch})`;
					if (sessionName) pwd += ` • ${sessionName}`;

					const lines = [
						truncateToWidth(theme.fg("dim", pwd), width, theme.fg("dim", "...")),
						buildStatsLine(width),
					];

					const statuses = footerData.getExtensionStatuses();
					if (statuses.size > 0) {
						const statusLine = Array.from(statuses.values())
							.map((s) => s.replace(/[\r\n\t]/g, " ").replace(/ +/g, " ").trim())
							.join(" ");
						lines.push(truncateToWidth(statusLine, width, theme.fg("dim", "...")));
					}

					return lines;
				},
			};
		});
	});
}
