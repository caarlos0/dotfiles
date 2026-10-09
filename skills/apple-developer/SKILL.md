---
name: apple-developer
description: Build, debug, and review native macOS, iPadOS, and iOS apps.
  Use for Swift, SwiftUI, UIKit, AppKit, Xcode, performance, platform UX,
  accessibility, persistence, Apple APIs, privacy, signing, StoreKit,
  TestFlight, and App Store submission work.
---

# Apple Developer

Build for the person, the platform, and the supported deployment targets.
Follow repository instructions first. Prefer system components and the
smallest design that meets the requirement. Do not turn a focused fix into
a framework migration.

## Establish the contract

Before changing code, find:

1. The user-visible problem and the expected result.
2. Supported platforms, minimum OS versions, and distribution channels.
3. The actual project or workspace, scheme, targets, and dependencies.
4. Xcode and Swift versions, Swift language mode, default actor isolation,
   and enabled concurrency features.
5. State ownership, persistence, entitlements, and existing tests.

Distinguish native macOS, Mac Catalyst, and an iPhone/iPad app running on
Mac. Do not infer one target's behavior from another. Separate deployment
target, build SDK, compiler version, and runtime capability.[^availability]

For a new app, propose the smallest vertical slice: one useful flow,
native navigation, explicit data ownership, and an observable failure
state. Add abstractions, packages, backends, or background services only
when a concrete requirement needs them.

## Read only the relevant references

| Task | Reference |
|---|---|
| Framework choice, state, scenes, Swift concurrency | [Architecture](references/architecture.md) |
| Navigation, visual design, input, accessibility, localization | [Design](references/design.md) |
| Slow launch, hangs, scrolling, memory, energy | [Performance](references/performance.md) |
| Storage, migrations, documents, sync, background work | [Data and lifecycle](references/data-lifecycle.md) |
| Permissions, secrets, disclosures, sandbox access | [Privacy](references/privacy.md) |
| System integrations, extensions, media, intelligence | [API map](references/apis.md) |
| Builds, tests, diagnostics, CI | [Build and test](references/build-test.md) |
| Signing, purchases, TestFlight, App Review, release | [Distribution](references/distribution.md) |

## Working rules

- Share domain logic where useful; adapt navigation, windows, commands,
  and input to each platform. Standard components are a starting point,
  not proof of good UX or complete accessibility.[^hig]
- Make state ownership explicit. Keep view rendering free of I/O and
  expensive computation. Use UIKit/AppKit bridges when they meet a real
  need; do not rewrite working code for SwiftUI alone.[^swiftui]
- Never assume `async`, `await`, or `Task {}` means background CPU work.
  Inspect isolation settings and measure the actual executor behavior.
  Cancellation is cooperative; identify who owns each task.[^concurrency]
- Preserve user data. Test migrations from shipped stores. Surface
  persistence failures instead of silently replacing a store with an
  empty one. Treat cloud sync and background execution as separate
  capabilities with their own limits.[^data]
- Request protected access at the point of use. Prefer a system picker
  when selection is sufficient. Handle limited, denied, restricted, and
  changed authorization where the framework exposes those states.[^privacy]
- Verify performance in an optimized build on representative hardware.
  Diagnose before caching, detaching tasks, or adding concurrency. Use
  app-specific budgets, not invented universal launch or memory limits.
  Keep sanitizer runs separate from performance measurements.[^performance]
- For commerce, separate purchase completion, verified entitlement,
  durable delivery, and transaction finishing. Pending and cancellation
  are not successful purchases.[^commerce]
- Do not change signing, publish builds, accept agreements, or change
  production records merely to investigate a local problem.

## Verify current information

The reference set was researched on **2026-10-09**. It is not a frozen
catalogue of the latest SDK or a guarantee of App Review approval.

Use current Apple documentation, HIG, release notes, Swift migration
guidance, and App Store Connect Help. Check the **specific symbol**, not
only its framework landing page. Confirm compile-time availability and
runtime hardware, permission, account, entitlement, language, and region
requirements.[^availability]

Before release, recheck SDK submission deadlines, privacy/SDK rules,
storefront-specific payment and distribution terms, TestFlight limits,
and agreement status. Never apply a US or EU rule worldwide. If live
sources cannot be checked, identify the uncertainty and do not claim
release readiness.[^release]

## Completion

Check the changed behavior, its failure path, and relevant regressions
with the repository's existing tools. Use the smallest useful test scope.
For UI changes, inspect the actual interface and relevant accessibility,
input, localization, and window-size states; compilation is not a UX
check.[^hig]

Report the result, important tradeoffs, and any unverified device,
platform, or release requirement. Do not imply that simulator success,
notarization, or TestFlight review guarantees production behavior or
App Store approval.[^release]

[^availability]: [Apple Developer Documentation](https://developer.apple.com/documentation/); [Swift migration guide](https://github.com/swiftlang/swift-migration-guide).
[^hig]: [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility); [Windows](https://developer.apple.com/design/human-interface-guidelines/windows).
[^swiftui]: [Managing model data](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app); [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable).
[^concurrency]: [Task](https://developer.apple.com/documentation/swift/task); [SE-0461](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md).
[^data]: [SchemaMigrationPlan](https://developer.apple.com/documentation/swiftdata/schemamigrationplan); [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks).
[^privacy]: [Protecting privacy](https://developer.apple.com/documentation/uikit/protecting-the-user-s-privacy).
[^performance]: [Improving responsiveness](https://developer.apple.com/documentation/xcode/improving-app-responsiveness); [Runtime diagnostics](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early).
[^commerce]: [PurchaseResult](https://developer.apple.com/documentation/storekit/product/purchaseresult); [Transaction.finish()](https://developer.apple.com/documentation/storekit/transaction/finish()).
[^release]: [App submission](https://developer.apple.com/app-store/submitting/); [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/); [Notarization](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution).
