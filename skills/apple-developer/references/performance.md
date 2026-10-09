# Performance and energy

## Measure the user-visible problem

Record the interaction, device, OS, build configuration, data volume, and
starting state. Separate cold launch, warm launch, and resume. For a
regression, compare the same flow and conditions before and after.
Set app-specific acceptance budgets from those baselines and shipping
metrics, not from a universal launch or memory number.[^shipping]

Profile an optimized build on representative hardware. Check the
scheme's Profile configuration; do not assume it cannot be customized.
Simulator behavior is useful for debugging, not a substitute for device
memory, thermal, energy, or hardware measurements. Keep sanitizers out
of baseline performance runs.[^diagnostics][^memory]

## Pick a tool from the symptom

| Symptom | Start with | Next question |
|---|---|---|
| Busy CPU, slow computation | Time Profiler | Which work dominates? |
| Frozen UI with little CPU | Hangs, thread states/System Trace | What is the main thread waiting for? |
| Scroll/animation stutter | Hitches and rendering instruments | Which frame stage misses its deadline? |
| Excess SwiftUI updates | SwiftUI instrument, where available | Which dependency causes the update? |
| Memory growth | Allocations generations, Memory Graph | What remains retained after the flow? |
| Suspected leaks | Leaks and allocation stacks | Which ownership path prevents release? |
| Battery/thermal issue | Power/energy instruments | Which subsystem stays active? |
| Field-only regression | Organizer, MetricKit where supported | Which versions/devices are affected? |

Use CPU samples for active work, not as proof that a blocked thread is
healthy. Correlate tracks over the same time interval. Availability of
individual instruments and metrics depends on Xcode, OS, and target.
MetricKit support does not mean every metric exists on every
platform.[^tools][^shipping]

Add signpost intervals to meaningful operations with distinct IDs for
overlapping work. Use them to connect user actions to CPU, I/O, rendering,
and measured latency. Do not log sensitive payloads merely to improve
trace detail.[^signposts]

## Protect responsiveness

Apple gives approximate guidance around 100 ms for discrete interaction
response and a display refresh interval for continuous updates.
At 60 Hz that interval is about 16.7 ms; at 120 Hz it is about 8.3 ms.
The app does not own the entire frame interval. These are engineering
guidelines, not App Store pass/fail limits or an app-specific SLA.
Instruments' hang-reporting threshold is not an acceptable UI latency
budget.[^response]

Remove unnecessary work before moving it to another executor. Keep
synchronous I/O, large parsing jobs, image decoding, and long loops away
from UI-critical execution. `Task {}` and `await` do not prove the work
left the main actor; see the architecture reference.[^response]

## SwiftUI and collections

Use the SwiftUI instrument to inspect long updates and their causes
where supported. Keep body evaluation cheap and observation dependencies
narrow enough to match the actual feature. Use stable identity.
Do not add `AnyView`, `.id()`, equality wrappers, or custom caches as
unmeasured performance remedies.[^swiftui]

Lazy stacks defer creation until needed; that alone is not a promise of
cell reuse or bounded memory. Choose `List`, lazy containers, or platform
collection views for the required interaction and measured workload.
Keep filtering, sorting, formatting, and row construction costs visible
when evaluating a large dataset.[^lazy]

## Images, memory, and lifetime

Decode or downsample images for the required pixel dimensions rather
than loading a full-resolution bitmap and merely shrinking its view.
Account for display scale. On supported UIKit targets, thumbnail
preparation APIs avoid unnecessary full-size decoding.[^images]

Investigate retained closures, tasks, observers, caches, and document
models with allocation generations and Memory Graph. Exercise a feature
repeatedly and inspect what remains after closing it. Do not call all
growth a leak: distinguish reusable allocations, live data, caches, and
unbounded retention.[^memory]

Cache only when measurement supports it. Give caches an explicit
identity, invalidation rule, and memory policy appropriate to the
workload. Test large inputs and memory pressure on hardware.

## Energy and regressions

Avoid continuous timers and polling when events or system scheduling
meet the requirement. Reduce redundant network work and batch deferrable
work where appropriate. Stop sensors, location updates, animations, and
unneeded tasks when their feature no longer needs them. Measure the
effect rather than assuming fewer lines means less energy.[^energy]

Finish with a same-condition comparison and a regression check that
matches the original problem. Preserve traces and relevant build/device
metadata. Use Organizer and available MetricKit data after release to
look for regressions not reproduced locally.[^shipping]

[^shipping]: [Shipping app performance](https://developer.apple.com/documentation/xcode/analyzing-the-performance-of-your-shipping-app); [MetricKit](https://developer.apple.com/documentation/metrickit); [Launch time](https://developer.apple.com/documentation/xcode/reducing-your-app-s-launch-time).
[^diagnostics]: [Runtime diagnostics](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early).
[^memory]: [Gathering memory information](https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use).
[^tools]: [Analyze hangs with Instruments](https://developer.apple.com/videos/play/wwdc2023/10248/); [Understanding hangs](https://developer.apple.com/documentation/xcode/understanding-hangs-in-your-app).
[^signposts]: [Recording performance data](https://developer.apple.com/documentation/os/recording-performance-data); [Logging](https://developer.apple.com/documentation/os/logging).
[^response]: [Improving app responsiveness](https://developer.apple.com/documentation/xcode/improving-app-responsiveness).
[^swiftui]: [Understanding SwiftUI performance](https://developer.apple.com/documentation/xcode/understanding-and-improving-swiftui-performance); [Optimize SwiftUI performance](https://developer.apple.com/videos/play/wwdc2025/306/).
[^lazy]: [Grouping data with lazy stacks](https://developer.apple.com/documentation/swiftui/grouping-data-with-lazy-stack-views).
[^images]: [Preparing a thumbnail](https://developer.apple.com/documentation/uikit/uiimage/preparingthumbnail(of:)).
[^energy]: [Power profiling](https://developer.apple.com/videos/play/wwdc2025/226/).
