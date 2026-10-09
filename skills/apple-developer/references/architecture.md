# Architecture, state, and concurrency

## Choose the smallest compatible structure

Use SwiftUI for interfaces it expresses well. Keep UIKit and AppKit when
the existing app or required interaction benefits from them. Embed SwiftUI
with hosting controllers/views; wrap platform views with representables.
A Coordinator connects delegate callbacks, not a second domain model.
Respect the layout and lifecycle contract of each bridge.[^bridges]

A useful boundary is:

```text
Platform scenes and views
        |
Feature state and user actions
        |
Domain rules and service interfaces
        |
Persistence, networking, and platform integrations
```

This is a responsibility map, not a requirement for four modules or an
MVVM framework. Follow existing repository patterns. Keep platform checks
near platform-dependent behavior rather than spreading them throughout
otherwise shared logic.

## Own state at its real lifetime

| Lifetime | Typical owner | Questions |
|---|---|---|
| App | App-level model or service | Is it truly shared across windows? |
| Scene/window | Scene root | Can two windows select different items? |
| Document | Document model | Who saves, coordinates, and undoes edits? |
| View | Local state | Does identity preserve it across updates? |
| Operation | Task owner | Who cancels it and observes its result? |

`WindowGroup` creates independent view storage for each window.
`DocumentGroup` integrates document workflows. Use scene lifecycle signals
for the relevant scene; do not assume one global active/background flag
describes every window.[^scenes]

For Observation-based models, place `@Observable` references in `@State`
at their owner. Use `@Bindable` when bindings to model properties are
needed. `ObservableObject`, `@StateObject`, and `@ObservedObject` remain
valid for existing code and earlier deployment targets. Do not replace
one ownership model with the other mechanically.[^state]

Use stable domain identifiers for collections. A newly generated ID on
each render changes identity and can reset local state. Keep derived work
in view bodies small; confirm invalidation causes before adding caches
or equality wrappers.[^identity]

## Concurrency: inspect settings before prescribing syntax

These are separate inputs:

- Compiler/toolchain version.
- Swift language mode and strict concurrency checking.
- Default actor isolation for unannotated declarations.
- Upcoming features such as `NonisolatedNonsendingByDefault`.

Under SE-0338, non-actor-isolated async functions execute on a generic
executor. SE-0461 changes the default for nonisolated async functions when
its feature is enabled, allowing them to remain on the caller's actor.
SE-0466 controls inference for unannotated declarations. Do not reduce
these rules to "Swift 6 always does X."[^isolation]

`Task {}` can inherit actor context. `await` marks a possible suspension,
not an instruction to move CPU work off the main actor. For expensive
work, first remove unnecessary work; then use an explicitly appropriate
non-main execution boundary supported by the project's toolchain.
`@concurrent` can express that boundary where available. Do not prescribe
bare `nonisolated async` or `Task.detached` as a universal fix.[^isolation]

Keep UI state on the correct actor. Pass values or suitable identifiers
across boundaries rather than unsafely sharing mutable model objects.
An actor prevents unsynchronized access to its isolated state, but an
`await` allows other work to run: recheck assumptions after suspension.
Use `Sendable` as a contract, not a warning to silence.[^actors]

`MainActor.run` can move execution onto the main actor.
`MainActor.assumeIsolated` does **not** move execution: it asserts the
current executor and can terminate on a mismatch. Do not use it to hide
an isolation error.[^mainactor]

## Give asynchronous work an owner

Use `async let` or task groups for scoped parallel work. A task group
waits for its children before returning; cancellation does not forcibly
stop them. Check cancellation during long loops and respect cancellation
from called APIs.[^tasks]

Use view-scoped tasks for work owned by a visible view, with identity
that reflects the requested content. Give app-level work an app-level
owner instead. Unstructured tasks need deliberate lifetime, cancellation,
error handling, and retention decisions. Do not use detached tasks merely
to remove compiler diagnostics.[^tasks]

Keep cancellation distinct from user-visible failure when cancellation
is expected. Reject stale results when an older request finishes after a
newer one; use cancellation and request identity where the feature needs
both. Test this race instead of assuming completion order.

## Review checks

- Two windows do not overwrite each other's transient selection.
- A view update does not recreate long-lived services.
- UI rendering, bridge updates, and actor-isolated UI code avoid blocking
  I/O and unbounded computation.
- Each asynchronous operation has an owner and a visible error path.
- No `@unchecked Sendable`, `nonisolated(unsafe)`, or isolation assertion
  was added without a documented synchronization argument.
- The change preserves supported OS targets and framework ownership
  rules.[^state][^actors][^isolation]

[^bridges]: [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable); [NSViewRepresentable](https://developer.apple.com/documentation/swiftui/nsviewrepresentable); [UIHostingController](https://developer.apple.com/documentation/swiftui/uihostingcontroller).
[^scenes]: [App](https://developer.apple.com/documentation/swiftui/app); [WindowGroup](https://developer.apple.com/documentation/swiftui/windowgroup); [DocumentGroup](https://developer.apple.com/documentation/swiftui/documentgroup); [ScenePhase](https://developer.apple.com/documentation/swiftui/scenephase).
[^state]: [Managing model data](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app); [Discover Observation in SwiftUI](https://developer.apple.com/videos/play/wwdc2023/10149/).
[^identity]: [Demystify SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10022/).
[^isolation]: [SE-0338](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0338-clarify-execution-non-actor-async.md); [SE-0461](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md); [SE-0466](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0466-control-default-actor-isolation.md).
[^actors]: [Protect mutable state with Swift actors](https://developer.apple.com/videos/play/wwdc2021/10133/); [Swift migration guide](https://github.com/swiftlang/swift-migration-guide).
[^mainactor]: [MainActor](https://developer.apple.com/documentation/swift/mainactor).
[^tasks]: [Task](https://developer.apple.com/documentation/swift/task); [TaskGroup](https://developer.apple.com/documentation/swift/taskgroup); [Beyond structured concurrency basics](https://developer.apple.com/videos/play/wwdc2023/10170/).
