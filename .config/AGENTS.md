## User Preferences

- Write descriptive commit messages, in Linux kernel style, follow 50/72 rule. Peek a few commits to mimic their title style. In general, do not prefix the title with subsystem name or conventional commits prefix, unless existing commits have them.
- When building git commit commands, never put a literal `\n` inside an argv string and expect the shell to turn it into a newline. Use an actual newline in the quoted text, repeated flags, or a file/stdin input path.
- Prioritize writing simple, concise, obviously correct code unless the inherent complexity prevents this approach.
- Use comments sparsely, and only for *why* code works a certain way when it's not obvious. Avoid comments that simply describe *what* the code does.
- If the task is unreasonable, infeasible or surprisingly complicated, clearly communicate this and discuss it with the user.
- Be very careful and explicitly ask the user before introducing automatic fallback logic, avoid them as possible.
- Code that crashes in the production loudly, even at 3am, is still much better than code that silently fails and fakes its success. If something failed, expose it. Write defensive code sparsely, when in doubt, don't do defensive programming.
  * For preconditions that should be impossible given correct program logic, use assertions (or crash), not error-code returns. Graceful error handling is for expected failure modes (I/O, user input, external APIs), not for "this should never happen" branches.
- Remove dead/obsolete code during migration. Apply common sense, and when in doubt, assume that you do NOT need to be compatible with old code, unless explicitly requested by the user.

## Language-specific Guidelines

### C++

Look at the codebase and try to blend in. If there are no existing consistent patterns, follow Google C++ Style Guide, unless specified otherwise. Additionally:

- Prefer `std::optional`, `std::expected` or `absl::StatusOr` (when available) for error handling. Exceptions are **not** banned, use them when appropriate, for example when interacting with libraries that use exceptions.
- Never log to std::cout, std::cerr or std::clog, unless in a standalone demo/PoC project. Look around and use the bespoke logging system.
- Never log and ignore an error, you must propagate it, and it's better to let it crash loudly if you don't know how to handle it **AND** can't propagate it without significantly more code. Use your own judgment.

### Python

- Never catch an exception just for printing logs and immediately re-raise it.
- Don't mask rare errors or handle them with disproportionate effort. Let them propagate if it leads to simpler code.
