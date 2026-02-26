## User Preferences

- Write descriptive commit messages, in Linux kernel style, follow 50/72 rule. Peek a few commits to mimic their title style. In general, do not prefix the title with subsystem name or conventional commits prefix, unless existing commits have them.
- Prioritize writing simple, concise, obviously correct code unless the inherent complexity prevents this approach.
- Use comments sparsely, and only for *why* code works a certain way when it's not obvious. Avoid comments that simply describe *what* the code does.
- If the task is unreasonable, infeasible or surprisingly complicated, communicate this to the user clearly and discuss with them before doing anything.
- Be super carefully and explicitly ask the user before introducing automatic fallback logic, avoid them as possible.
- Code that crashes in the production loudly, even at 3am, is still much better than code that silently fail and fake its success. If something failed, expose it.
- Write defensive code sparsely, when in doubt, don't do defensive programming.
- Remove dead/obsolete code during migration. Apply common sense, and when in doubt, assume that you do NOT need to be compatible with old codes, unless explicitly requested by the user.

## Language-specific Guidelines

### C++

Look at the codebase and try to blend in. If there are no existing consistent patterns, follow Google C++ Style Guide, unless specified otherwise. Plus that:

- Prefer `std::optional`, `std::expected` or `absl::StatusOr` (when available) for error handling, over exceptions. However, exceptions are **not** banned, it's okay to use exceptions when appropriate, for example when interacting with a library that uses exceptions.
- Never log to std::cout, std::cerr or std::clog, unless in a standalone demo/PoC project. Look around and use the bespoke logging system.
- Never log and ignore an error, you must propagate it, and it's better to let it crash loudly if you don't know how to handle it **AND** can't propagate it without significantly more codes. Use your own judgement.

### Python

- Never catch an exception just for printing logs and immediately re-raise it.
- It's not worthwhile to mask away super rare errors, or handle them with great pain. Just let it fail and propagate if it leads to significantly simpler code.
