# Build, test, and diagnose

## Discover the real build entry point

Read repository instructions and existing CI first. Identify whether
the product builds through an Xcode workspace, an Xcode project, SwiftPM,
or a repository wrapper. Workspace presence alone does not prove it is
the correct entry point.

Read-only discovery examples:

```sh
xcode-select -p
xcodebuild -version
swift --version
xcodebuild -list -json -workspace 'App.xcworkspace'
xcodebuild -showdestinations -workspace 'App.xcworkspace' -scheme 'App'
```

Names are placeholders. Use `-project 'App.xcodeproj'` instead of
`-workspace` when that is the repository's entry point; do not pass both.
Use reported schemes and destination IDs, not guessed simulator names.
Inspect the active test plan and language/isolation settings.[^cli]

## Run the smallest useful check

Example app test command; replace every project-specific value:

```sh
xcodebuild test \
  -workspace 'App.xcworkspace' \
  -scheme 'App' \
  -destination 'platform=iOS Simulator,id=SIMULATOR-UDID' \
  -only-testing:'AppTests/FeatureTests/testExpectedBehavior' \
  -resultBundlePath 'artifacts/feature-test-UNIQUE.xcresult'
```

Use a fresh result-bundle path and keep enough output to diagnose errors.
For native Mac tests, use a supported Mac destination from discovery.
The shown test identifier is an XCTest-style example; inspect discovery
output for the project's actual framework and identifiers.[^cli]

For repeated runs, `build-for-testing` produces artifacts that
`test-without-building` can use. Supply the matching scheme/destination
or a generated `.xctestrun` specification. Rebuild if sources, toolchain,
configuration, or required artifacts change.[^cli]

For package-only logic, use the repository's SwiftPM commands, such as
`swift test --filter 'REGEX'`. SwiftPM's regular-expression filter is
not xcodebuild's slash-separated XCTest identifier. Package tests do not
replace app launch, entitlements, UI, or device integration checks.[^testing]

## Match the test to the defect

| Change | Useful evidence |
|---|---|
| Domain rule | Focused unit tests and boundary values |
| Concurrent operation | Cancellation, stale result, error propagation |
| Persistence | Old-store fixtures, migration result, save failures |
| UI interaction | XCTest UI flow, accessibility, relevant window sizes |
| Performance | XCTest metrics or same-condition Instruments comparison |
| Purchase handling | StoreKit configuration and sandbox lifecycle cases |
| Device integration | Physical device and permission/lifecycle states |

Swift Testing supports modern unit tests and runs tests in parallel by
default. Isolate shared resources and control concurrency deliberately.
Keep XCTest where needed for UI automation, performance metrics, or
existing suites. Both frameworks can coexist; a feature fix does not
require a test-framework migration.[^testing]

For asynchronous tests, wait for explicit completion or state with
bounded waits. Do not use arbitrary sleeps as synchronization.
Control clocks, data, network dependencies, and operation ordering where
the test needs them. A callback observed once does not prove a
cancellation or stale-result invariant.[^async]

## Diagnostics and hardware

Use the applicable Address/Thread sanitizers and Main Thread Checker for
memory, race, and UI-thread defects. Respect platform/toolchain support
and overhead. Diagnose with instrumented runs; measure performance in
separate optimized, uninstrumented runs.[^diagnostics]

Use simulator coverage for fast iteration, then representative physical
devices for hardware, energy, memory pressure, camera/sensors, and
device-specific behavior. Test the minimum supported OS as well as the
current one when the change affects availability.[^diagnostics]

Accessibility Inspector and automated accessibility audits help find
defects. They do not replace completing the flow with VoiceOver,
keyboard, or other relevant assistive technology.[^accessibility]

## Reproducibility and CI

Record the Xcode/Swift version, dependency resolution, scheme,
configuration, destination, and source revision for a build.
Use the existing dependency lockfiles and project generation tools.
Do not hand-edit generated project files if the repository has an
authoritative generator.

Keep `.xcresult` diagnostics, archives, and matching dSYMs for
distributed builds. Symbolication depends on matching binary UUIDs,
not merely matching the marketing version.[^symbols]

Scope signing credentials and App Store Connect access to the CI job.
Use managed credentials or the repository's secure mechanism, never
inline private keys or shared account passwords. Do not disable signing
or add broad entitlements to make a failing release job pass.
Xcode Cloud is an option, not a requirement to replace existing CI.[^ci]

[^cli]: [Apple TN2339: command-line builds and tests](https://developer.apple.com/library/archive/technotes/tn2339/_index.html); local `xcodebuild -help` verified during research on 2026-10-09. Recheck the installed help for current options.
[^testing]: [Swift Testing](https://developer.apple.com/documentation/testing); [Parallelization](https://developer.apple.com/documentation/testing/parallelization); [XCTest](https://developer.apple.com/documentation/xctest); [Running tests](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results); local `swift test --help` verified on 2026-10-09.
[^async]: [XCTestExpectation](https://developer.apple.com/documentation/xctest/xctestexpectation).
[^diagnostics]: [Runtime diagnostics](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early); [Memory information](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use).
[^accessibility]: [Accessibility Inspector](https://developer.apple.com/documentation/accessibility/accessibility-inspector).
[^symbols]: [Debugging information and dSYMs](https://developer.apple.com/documentation/xcode/building-your-app-to-include-debugging-information).
[^ci]: [Distributing an app](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases); [Xcode Cloud](https://developer.apple.com/documentation/xcode/xcode-cloud).
