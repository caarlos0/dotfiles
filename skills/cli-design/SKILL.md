---
name: cli-design
description: Design and review command-line interfaces for usability, automation, safety, accessibility, and long-term compatibility. Use when adding or changing commands, flags, help, output, prompts, configuration, or exit behavior.
user_invocable: true
---

# CLI Design

Treat a CLI as both a human interface and a stable automation API. Follow
repository instructions and existing command conventions before introducing a
new grammar, output format, exit status, or configuration mechanism.

## Define the contract first

Before implementation, identify separately:

1. The human workflows: discovery, common use, mistakes, recovery, and advanced
   use.
2. The automation workflows: unattended execution, input, output parsing,
   failure handling, and composition with other tools.
3. The public contract: commands, options, operands, defaults, streams, exit
   statuses, prompts, environment variables, configuration, and structured
   output.

Write representative invocations before choosing a parser or framework:

```text
tool [global-options] <command> [command-options] [operands]
```

Use noun/verb subcommands when they fit the domain, but preserve an established
project grammar. Prefer a shallow, regular hierarchy over many special cases.

## Design predictable commands

- Give commands and long options lowercase, descriptive, spellable names.
- Use commands for actions and options for parameters or behavior modifiers.
- Keep the same concept named and spelled consistently across commands.
- Reserve short options for frequent operations and provide a descriptive long
  equivalent. Do not assign every option a short form.
- Prefer explicit options over ambiguous positional arguments. Use positional
  operands when their meaning and order are obvious.
- Support `--` before operands so names beginning with `-` remain addressable.
- Where file operands make sense, consider `-` as stdin or stdout and document
  the exact behavior.
- Decide whether options may appear after operands, whether short options may be
  grouped, and how optional values parse. Document and test the decision.
- Do not accept arbitrary command abbreviations. Suggest likely corrections,
  but never silently execute a guessed command.
- Treat aliases as compatibility interfaces. Add one only when it is worth
  supporting for the lifetime of the CLI.
- Avoid implicit catch-all behavior that turns a typo into another valid,
  potentially destructive operation.

Familiar options such as `--help`, `--version`, `--quiet`, `--verbose`,
`--output`, `--json`, `--color`, `--no-input`, and `--dry-run` should retain
 their conventional meaning.

## Make help useful at the point of failure

- Provide `-h` and `--help` at every command level unless an established
  compatibility contract prevents it.
- Help must exit successfully without performing normal work, loading remote
  data, or requiring valid credentials or configuration.
- Order help for scanning: purpose, usage, common examples, common options,
  remaining options or commands, then further documentation.
- Lead with realistic examples, including piped or unattended use where
  relevant.
- Show defaults, accepted values, units, repetition rules, conflicts, and
  whether an option can be supplied through configuration or environment.
- For invalid input, explain the specific problem and show only the relevant
  usage or hint. Do not print the entire manual after every typo.
- Distinguish parse errors from operational failures.
- For large CLIs, keep default help concise and provide a full-help or reference
  tier.
- Generate help, shell completion, and reference documentation from the same
  command model where practical so they cannot drift.

Completion must tolerate incomplete input and must be fast, non-interactive,
side-effect-free, and safe when configuration, credentials, or the network are
unavailable. Avoid remote completion unless it is explicitly bounded and has a
local fallback.

## Keep the stream contract strict

- Write requested result data to stdout.
- Write diagnostics, warnings, prompts, progress, and debug information to
  stderr.
- Do not write headings, notices, progress, or ANSI control sequences into
  machine-readable stdout.
- Assert stdout, stderr, and exit status independently in tests.
- Keep `--quiet` limited to nonessential messaging. It must not change result
  semantics, suppress required errors, or turn failure into success.
- Send verbose or debug diagnostics to stderr and redact secrets.

Human-readable tables and prose may evolve for usability. Do not require
scripts to parse them. When automation is expected, provide an explicit stable
format such as:

- JSON for one bounded result;
- JSON Lines for streamed records or events;
- plain delimited fields where JSON is excessive;
- templates or field selection for user-controlled rendering;
- NUL-delimited output when values may contain whitespace or newlines.

Document machine-output fields, types, nullability, encoding, framing, ordering,
and compatibility policy. If ordering is not guaranteed, say so. Human and
machine renderers should consume the same application result rather than
implementing behavior separately.

## Define exit behavior deliberately

Return zero only for documented success. Use a small, stable, documented set of
nonzero statuses rather than exposing arbitrary internal errors.

Decide explicitly how the command reports:

- invalid usage;
- operational failure;
- authentication or authorization failure;
- missing resources;
- empty or no-match results;
- cancellation or interruption;
- partial success;
- accepted or pending asynchronous work.

Do not let partial success look like full success. Report completed and failed
items separately and choose an exit status that allows automation to detect the
failure.

Follow established shell conventions where applicable, but do not invent
portable meaning for every numeric status. Document the statuses that callers
are expected to branch on.

Handle broken pipes as normal pipeline termination when the platform and command
semantics permit it. Do not replace useful output with a stack trace because a
downstream command stopped reading.

## Write actionable errors

Expected user-facing failures should answer:

1. What failed?
2. Why did it fail?
3. What can the user do next?

Use domain language rather than parser, transport, or stack internals. Include
the relevant resource, option, configuration source, or rejected value without
revealing secrets.

- Put the primary error first and actionable hints afterward.
- Name the exact replacement option or command when suggesting a fix.
- Show concise contextual usage for usage errors.
- Preserve the underlying cause for debugging without dumping a stack trace by
  default.
- Group repeated failures when one explanation applies to many items.
- Never catch an error merely to return success-shaped output or an empty
  result.

Represent errors structurally inside the application, with a stable category or
code, user message, optional hints, underlying cause, and exit status. Render
them only at the process boundary.

## Keep TTY behavior presentational

Detect stdin, stdout, and stderr independently. They may point to different
kinds of destinations.

TTY state may control:

- color and styling;
- paging;
- wrapping and headings;
- buffering;
- progress animation;
- whether prompting is possible.

TTY state must not silently change the selected resources, operation, result
schema, or other command semantics.

- Disable cursor motion, animation, and paging when their output stream is not
  a terminal unless explicitly forced.
- Never prompt unless both input and prompt output are usable terminals.
- Keep redirected and CI output linear and stable.
- Support `NO_COLOR`, `TERM=dumb`, and an explicit color mode such as
  `--color=auto|always|never`.
- Never encode meaning with color alone. Pair it with text, symbols, or
  structure.
- Sanitize untrusted terminal control sequences before displaying external
  data.
- Restore terminal state after cancellation and failure.

Use a pager only for long human-readable output, only when appropriate for the
output destination, and provide a way to disable it. Do not page structured
output.

## Make interactivity optional

Every prompt must have a complete unattended equivalent through an option,
operand, stdin, configuration, or environment variable.

- Provide `--no-input` or an equivalent control when commands might prompt.
- In non-interactive mode, fail immediately and name the missing input and its
  replacement option.
- Display prompt defaults explicitly. Destructive choices should default to the
  safe answer.
- Do not infer consent merely because stdin is closed or output is redirected.
- Keep prompt wording, accepted answers, and cancellation behavior consistent.
- Treat Ctrl-C as cancellation: stop starting new work, restore terminal state,
  and return the documented cancellation status.

Do not make a full-screen or interactive selector the only route to an
operation. Share application logic between interactive and non-interactive
adapters. Use `tui-design` when the task specifically involves a full-screen
terminal interface.

## Scale safety to consequences

For risky operations, show the target, scope, count, and consequences before
execution or confirmation.

- Do not confirm low-risk actions that the user explicitly requested.
- Use a yes/no confirmation for moderate risk.
- Require a typed resource name or similarly strong confirmation for broad,
  destructive, externally visible, or hard-to-reverse operations.
- Prefer reliable undo over confirmation when undo is genuinely available.
- Provide `--dry-run` for bulk, remote, destructive, or otherwise
  hard-to-reverse operations.
- Make dry-run follow real selection, validation, and planning paths; only the
  final side effect should differ.
- Keep `--force` narrow. It may bypass a named confirmation or conflict, but
  must not bypass validation, authentication, or authorization.
- Make retries and idempotency deliberate for remote mutations. Do not repeat an
  operation automatically unless duplicate execution is safe or detectable.

Never accept secrets through ordinary argv when a safer channel is available;
process arguments may be visible to other processes, logs, and shell history.
Prefer hidden prompts, stdin, restricted files, file descriptors, credential
stores, or secret managers.

Invoke subprocesses with argument vectors. Never build a shell command by
interpolating untrusted values, and use `--` before untrusted operands when the
target command supports it.

## Make configuration explainable

Define and test one precedence order. A strong default, from lowest to highest,
is:

```text
built-in defaults
< system configuration
< user configuration
< project or workspace configuration
< environment variables
< command-line options
```

Adapt the order when the product has an established contract, but document it.

- Preserve the source of each effective value for diagnostics.
- Report malformed configuration with the file, field, and source location.
- Do not silently ignore an invalid higher-precedence value and fall back to a
  lower one.
- Define whether maps, lists, and repeated values merge or replace.
- Provide a way to inspect effective configuration and provenance when the
  system is complex.
- Separate configuration, data, state, cache, and runtime files.
- Follow platform conventions; use XDG base directories on Unix-like systems
  where appropriate.
- Load expensive or failure-prone configuration lazily so `--help`,
  `--version`, and static completion remain reliable.

Environment variable names and configuration paths are public interfaces.
Changing them requires the same compatibility care as changing an option.

## Keep the CLI adapter thin

Separate command mechanics from application behavior:

1. Parse syntax and perform primitive validation.
2. Convert parser values into framework-independent request types.
3. Invoke application logic through narrow dependencies.
4. Produce a framework-independent result or structured error.
5. Render the selected human or machine format.
6. Decide the final exit status at the top-level process boundary.

Keep networking, filesystem access, prompts, clocks, and process execution out
of parser callbacks. Do not terminate the process from reusable application
code.

Use one composition root. Inject only dependencies needed by the operation.
This keeps domain behavior reusable by commands, tests, background work, and
interactive interfaces.

## Preserve compatibility deliberately

Before changing an existing CLI, inspect all public surfaces:

- command and subcommand names;
- options, aliases, defaults, and positional order;
- parsing rules;
- prompts and unattended behavior;
- stdout, stderr, color, progress, and paging;
- exit statuses;
- environment variables and configuration paths;
- machine-readable fields, types, ordering, and framing;
- shell completion and generated documentation.

Prefer additive changes. A usability improvement is still a breaking change if
scripts depend on the old behavior.

For deprecations:

- keep the old interface working during the stated migration window;
- emit one concise warning on stderr;
- name the replacement and, where useful, show the equivalent invocation;
- document the removal release or policy;
- keep completion behavior intentional;
- add a compatibility test for both the deprecated and replacement forms.

Version structured output when consumers cannot safely absorb an incompatible
schema change. Do not use a product version bump as a substitute for a
migration path when compatibility can reasonably be preserved.

## Verify the real contract

Use the lowest test layer that proves each behavior, plus focused full-process
tests for the command boundary.

Test at least the relevant cases:

- root and subcommand help, with exit zero and no side effects;
- unknown command, unknown option, missing value, extra operand, and `--`;
- operands beginning with `-`;
- stdout, stderr, and exit status captured separately;
- TTY, redirected, piped, CI, `TERM=dumb`, and `NO_COLOR` behavior;
- prompted and option-driven paths, `--no-input`, closed stdin, and Ctrl-C;
- dry-run and destructive confirmation;
- every documented exit class, including empty and partial results;
- parseable structured output with the documented fields and types;
- absence of progress, prompts, and ANSI sequences in machine output;
- configuration precedence, invalid values, and source diagnostics;
- completion for incomplete input without prompts or side effects;
- deprecated syntax and its replacement;
- broken-pipe and cancellation cleanup.

Normalize paths, timestamps, terminal width, and colors in tests only when they
are not part of the contract. Use `writing-tests` for determinism and process
testing guidance, and `change-impact-auditor` when changing defaults,
configuration, protocols, or shared output models.

## Review failures

Flag these as defects unless the project documents a deliberate exception:

- scripts must parse decorative human tables or prose;
- result data and diagnostics share the same stream;
- JSON or plain output contains progress, prompts, or ANSI sequences;
- an error or partial operation exits as full success;
- a command prompts without a non-interactive path;
- redirected output changes operation semantics rather than presentation;
- secrets appear in argv, logs, diagnostics, or generated commands;
- untrusted text is interpolated into shell commands;
- configuration precedence or merge behavior is undefined;
- malformed configuration silently falls back;
- completion performs mutations, prompts, or unbounded network work;
- structured-output schemas change without compatibility consideration;
- aliases, defaults, exit codes, or parsing behavior break without migration;
- a guessed command is executed after a typo.

## References

These principles are based on established standards and mature CLI practice:

- POSIX Utility Syntax Guidelines:
  <https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap12.html>
- GNU command-line and help conventions:
  <https://www.gnu.org/prep/standards/html_node/Command_002dLine-Interfaces.html>
- Command Line Interface Guidelines:
  <https://clig.dev/>
- Stable Git porcelain output:
  <https://git-scm.com/docs/git-status#Documentation/git-status.txt---porcelainversion>
- GitHub CLI exit-code documentation:
  <https://cli.github.com/manual/gh_help_exit_codes>
- NO_COLOR:
  <https://no-color.org/>
- XDG Base Directory Specification:
  <https://specifications.freedesktop.org/basedir-spec/latest/>
- OWASP OS Command Injection Defense:
  <https://cheatsheetseries.owasp.org/cheatsheets/OS_Command_Injection_Defense_Cheat_Sheet.html>
