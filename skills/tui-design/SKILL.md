---
name: tui-design
description: Design terminal user interfaces and interactive CLIs that stay usable, accessible, and scriptable. Use when building or reviewing a TUI, a full-screen terminal app, or an interactive command-line tool.
user_invocable: true
---

# TUI Design

Design the command-line interface first. Add a full-screen TUI only when the
task needs persistent context, fast navigation, selection, or live updates.
A TUI owns the screen, the input, the scrollback, and the terminal state; do
not take that cost without a reason.

## Decide if a TUI is correct

- Use a plain command when the operation is one-shot, batchable, or scripted.
- Use the user's `$PAGER` when the task is reading or searching long output.
  Page only when stdout is a terminal, and provide `--no-pager`.
- Use a TUI when users repeatedly navigate, compare, filter, select, or watch
  changing data. Process monitors, resource browsers, and Git interfaces are
  good examples.
- Do not build a TUI only to get color or animation. Styled output, a prompt,
  or a single selector is usually enough.
- Never make the TUI the only way to do an important operation. Ship
  equivalent non-interactive subcommands and structured output:

  ```bash
  app                  # optional interactive interface
  app list --json
  app delete ID --yes
  ```

- Share the domain logic below both interfaces. The TUI is an adapter.

## Keep the two interfaces separate

- Write results to stdout and write progress, warnings, and errors to stderr.
- Test each stream for a terminal independently. stdout can be a pipe while
  stderr is still a terminal.
- When output is not a terminal, change presentation only, never meaning.
  Remove color, cursor motion, progress animation, and the alternate screen.
- Provide `--json` for structured data and one JSON document per line for
  streaming events. Treat those schemas as a public interface.
- Prompt only when stdin is a terminal. Provide a flag for every prompt so a
  script can supply the answer. Never block a pipeline on input.
- Support `-q`/`--quiet` and `--verbose`, with the same meaning everywhere.

## Lay out for a character grid

- Make 80x24 the minimum target. Essential navigation, current state, primary
  actions, and errors must stay usable there.
- Recompute the layout from the current size on every resize. Handle
  `SIGWINCH`, then query the real dimensions; do not cache the launch size.
- Use explicit breakpoints. Drop decoration and secondary metadata before you
  hide primary content. Below the minimum, print a plain "terminal too small".
- Clamp sizes before subtracting. Test 1x1, 20x5, and zero-size reports.
- Give headers, status bars, and key hints fixed heights; give the main view
  the rest; set minimum sizes on interactive panes.
- Wrap prose. Truncate scan-oriented rows with an ellipsis and offer a detail
  view. An ellipsis signals hidden content; silent clipping does not.
- Use the alternate screen for sustained applications, and inline rendering
  for command-shaped work that should leave output in scrollback.
- Spend borders carefully: two bordered panes cost at least four columns at
  80. Prefer whitespace, alignment, and one shared divider.

## Handle text as the terminal sees it

- Measure rendered cells, not bytes, code points, or string length. CJK is
  usually two cells, combining marks are zero, and one emoji may be many code
  points.
- Cut and edit at grapheme-cluster boundaries, not code points.
- Do not treat East Asian Width as a complete width algorithm; ambiguous
  characters vary by terminal, locale, and font.
- Keep emoji out of borders, fixed columns, progress tracks, and cursors.
  Reported widths disagree across terminals and multiplexers.
- Treat Nerd Font and Powerline glyphs as optional. Keep an ASCII fallback and
  never let an unlabeled icon be the only meaning.
- Normalize tabs to a fixed width before measuring.

## Use color as an enhancement

- Design a readable monochrome hierarchy first, then add semantic color.
- Support the ladder: no color, 16 colors, 256 colors, true color. Detect the
  capability; do not assume true color, and remember `COLORTERM` is lost
  through ssh and sudo.
- Define roles such as muted, surface, selected, success, warning, and error.
  Map roles through themes; do not scatter literal colors in the code.
- Detect the terminal background before you choose fixed colors, and keep an
  unknown state for terminals that do not answer.
- Never encode meaning in color alone. Add a label, symbol, border, or cursor.
- Honor `NO_COLOR` when it is present and not empty. An explicit flag or the
  user config may still override it.
- Target 4.5:1 contrast for ordinary text. You do not control the user's font
  size, theme, or rendering.

## Bind keys that every terminal can send

- Support arrows and `hjkl`. Show arrows in the footer and the vim aliases in
  the full help.
- Make `Ctrl+C` a global, highest-priority exit that no focused widget can
  shadow. It must restore the terminal before it exits.
- Bind `q` to quit at the root, `?` to full help, `/` to filter, `:` to a
  command palette, `Enter` to activate, `Tab`/`Shift+Tab` to move focus.
- Give `Esc` one consistent ladder: close a menu, cancel an edit or filter,
  close the overlay, go back one level. At the root it does nothing.
- Leave `Ctrl+S`, `Ctrl+Q`, `Ctrl+D`, and `Ctrl+Z` alone. They belong to the
  terminal and the shell.
- Do not require `Ctrl+Shift`, `Ctrl+Enter`, or a Tab and `Ctrl+I`
  distinction. Legacy terminals cannot encode them. Use the Kitty keyboard
  protocol only for optional accelerators.
- Keep mouse support off by default unless direct manipulation is central.
  Mouse reporting breaks ordinary text selection; document the Shift or Option
  override, and keep full keyboard equivalence.

## Make the interface discoverable

- Keep a one-line footer with three to six actions for the current focus, for
  example `up/down move  Enter open  / filter  ? help  q quit`.
- Derive the footer from the active keymap so it cannot drift from reality.
- `?` opens a full help overlay grouped by global, navigation, current pane,
  actions, and search.
- List aliases together, and never advertise a key that does nothing. Dim
  disabled actions and give the reason.
- Show the active sort, filter, mode, and match count. Do not overload plain
  typing silently.
- Treat empty states as content. Distinguish "nothing exists", "no match",
  "loading", "failed", and "no access", and give the next action:
  `No matches for "prod". Press Esc to clear the filter.`

## Report state and errors honestly

- Print something within 100ms. Silence during slow work looks like a hang.
- Use a spinner only for unknown durations; switch to counts or a progress
  measure when totals are known. Always label what is happening.
- Stop animation on success, failure, cancellation, or non-interactive output,
  and keep the frame rate low enough for ssh and slow terminals.
- Show loading inside the affected pane and keep the surrounding context.
- Every error answers three questions: what failed, why, and what to do next.
  Rewrite low-level errors into domain language. Put the action last.
- Group repeated failures under one explanation instead of one paragraph each.
- Keep recoverable errors inside the TUI, preserve the user's input and
  selection, and offer the retry key. Restore the terminal before a fatal
  error prints.
- Confirm irreversible, broad, or externally visible actions, and name the
  target: `Delete 12 pods in production?` Default the focus to cancel.
- Do not confirm actions with reliable undo. Offer undo instead, and only
  advertise it when recovery is guaranteed.

## Structure the application

- Keep one source of truth for state, and one serialized path for every
  visible state transition.
- Make the update step a deterministic transition: no clock, no filesystem, no
  network, no globals inside it.
- Turn every occurrence into a typed event: keys, resize, ticks, completion,
  failure, cancellation.
- Return descriptions of effects instead of performing them in the update
  step. Keep rendering pure and cheap.
- Keep the event loop free. Anything slower than a few milliseconds is worker
  work that sends its result back as an event.
- Cancel stale work and also reject stale results with a generation counter;
  an old response must never overwrite a newer one.
- Tie worker lifetime to the screen or widget that started it.
- Keep the domain packages free of the TUI framework, of styling, and of
  terminal APIs, so the same code serves `--json`, tests, and scripts.
- Reuse existing primitives for lists, tables, viewports, inputs, and help
  before writing your own; they already solved Unicode, scrolling, and paste.
- Never log to the stream the TUI owns. Log to a file and `tail -f` it from a
  second terminal. Debug from a second process.

## Own the terminal state

- Centralize acquisition and restoration. Track raw mode, alternate screen,
  hidden cursor, mouse capture, focus reporting, and bracketed paste, and undo
  them in reverse order.
- Restore on normal exit, on error, on panic, on `SIGINT`, and on `SIGTERM`.
  Make cleanup idempotent and best effort.
- Treat pasted text as data, not as keybindings, and bound its size.
- Accept that `SIGKILL` cannot be handled. Document `reset` or `stty sane`.
- Render on state change, not in a free loop. Build the next frame, diff it,
  and write only the changed cells. Do not clear the whole screen every frame.
- Virtualize long lists, key the selection by item identity rather than row
  position, and bound streaming queues so producers apply backpressure.

## Configure with a clear precedence

- Order: flags, environment variables, project config, user config, system
  config, built-in defaults. Provide a command that shows effective values and
  their source.
- Match the mechanism to the lifetime: flags vary per run, environment varies
  per machine, project files are shared, user config is personal.
- Follow XDG: `XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `XDG_DATA_HOME`,
  `XDG_CACHE_HOME`, `XDG_RUNTIME_DIR`.
- Ship a complete default keymap and theme. High configurability without a
  good baseline is onboarding debt. Make reset easy.
- Map keys to semantic actions such as `item.open`, not to functions, and
  detect conflicts.

## Design for screen readers

- Assume a screen reader sees a text buffer, not your widgets. Borders and
  coordinates carry no meaning to it.
- Provide a first-class linear mode: `--plain`, `--no-interactive`, or an
  accessible prompt mode that echoes context and asks one question at a time.
- Do not assume a framework is accessible because it is popular. Verify with
  NVDA, JAWS, and VoiceOver separately; snapshot tests prove nothing here.
- Keep a real cursor where the user's attention is.
- There is no portable accessibility environment variable. `NO_COLOR` is the
  only established convention; anything else must be documented and paired
  with a flag.

## Verify it

- Test state transitions without a terminal: send an event, assert the new
  state and the requested effect.
- Snapshot the rendered buffer at fixed sizes. Cover narrow, wide, empty,
  Unicode, selected, error, and loading states.
- Golden-test the plain contract with redirected streams, `TERM=dumb`, and
  `NO_COLOR=1`. Assert that no escape sequence, prompt, or timestamp appears.
- Add pseudo-terminal tests for lifecycle: raw mode, resize, paste, `Ctrl+C`,
  `SIGTERM`, and panic. After each failure path, assert the terminal was
  restored.
- Exercise the real thing through ssh and tmux, and on more than one emulator.
- Use recorded tapes for documentation, not as the regression gate.

## Related skills

- `writing-tests` for deterministic tests, including the TUI cases above.
- `code-review` when reviewing someone else's terminal interface.
- `go-conventions` when the implementation is Go.
