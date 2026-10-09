# API and capability map

Use this map to choose where to investigate. It is not a promise that
every symbol is available on every target.

For each selected API, verify:

1. The specific symbol's availability and the installed SDK.
2. Native macOS, Catalyst, iOS, and iPadOS differences.
3. Hardware, runtime state, and account requirements.
4. Entitlements, purpose strings, and authorization.
5. Extension/background limits, region, and language constraints.
6. A usable fallback or a clear unsupported state.

Framework landing-page metadata can differ from individual symbols.
Do not generate minimum-OS tables by treating one module version as the
availability of everything inside it.[^catalog]

## System integration and discovery

| User need | Investigate | Design check |
|---|---|---|
| Actions in Shortcuts/Siri/system surfaces | App Intents, App Shortcuts | Stable actions/entities, authentication |
| Find app content | Core Spotlight | Index lifecycle, deletion, privacy |
| Continue a task across devices | NSUserActivity, Handoff | Restorable activity, safe identifiers |
| Open app content from a website | Universal links, Associated Domains | AASA and entitlement agree; validate input |
| Glanceable information | WidgetKit | Timeline, stale state, update budget |
| Ongoing user-visible event | ActivityKit | Supported surfaces, end state, push lifecycle |
| Share data with own extensions | App Groups | Shared-container ownership and synchronization |
| Receive shared content or expose files | Share/File Provider extensions | Extension-safe APIs and bounded work |

Choose an integration only when it adds a useful entry point. Reuse the
same domain operation and authorization rules instead of implementing a
second version inside an intent, widget, or extension.[^integration]

Widget refresh is system-budgeted, not an exact timer.
Live Activities are not permanent background execution and their
rendering surfaces do not imply native ActivityKit availability on every
device. Verify the current activity and push contracts before promising
duration or update frequency.[^widgets]

An App Group is not a general permission to access unrelated apps.
Handle simultaneous access from the app and extensions. Do not assume
all app APIs are extension-safe or that a share extension can run
indefinitely.[^groups]

## Media, documents, and rendering

| Need | Frameworks | Important boundary |
|---|---|---|
| Playback UI | AVKit | Prefer system playback behavior |
| Capture, media processing, audio | AVFoundation | Permission, audio session, interruptions |
| User-selected photos | PhotosUI | Selected access versus full PhotoKit access |
| PDF reading/annotation | PDFKit | Document access, memory, accessibility |
| Web content | WebKit | Navigation, script/native bridge, trust boundary |
| Images and filters | Core Image | Decode size and processing cost |
| Custom GPU rendering/compute | Metal | Hardware support, memory, frame budget |
| Screen capture | ScreenCaptureKit or target-supported APIs | Consent and exact platform contract |

Start with the higher-level framework that meets the job. Use lower-level
rendering or capture APIs for demonstrated requirements, not merely
because they expose more control. Check current screen-capture support
per target rather than assuming either permanent macOS exclusivity or
universal availability.[^media]

## Device and personal data

| Need | Frameworks | Check before implementation |
|---|---|---|
| Maps and geographic presentation | MapKit | Region, network, content needs |
| Device location | Core Location | Precision, duration, foreground/background use |
| Bluetooth peripherals | Core Bluetooth | Hardware, permissions, lifecycle limits |
| Motion/sensors | Core Motion | Sensor availability on the actual device |
| Health data | HealthKit | Per-type authorization, platform support, policy |
| Home accessories | HomeKit | Entitlement, authorization, target support |
| Game Center features | GameKit | Authentication and capability configuration |

Do not infer hardware from successful compilation or import statements.
For sensitive or regulated features, use the dedicated framework and
policy guidance as part of the design, not just at submission.[^device]

## Intelligence and language

| Need | Starting point | Main constraint |
|---|---|---|
| App-supplied ML model | Core ML | Model cost, compute support, quality |
| Image understanding/OCR | Vision | Request-specific support and input quality |
| Tokenization/classification/language tasks | Natural Language | Language and model coverage |
| Speech transcription | Speech | Permission, assets, language, runtime support |
| System language-model integration | Foundation Models | Model/provider availability and privacy |

For system models, check runtime availability such as
`SystemLanguageModel.availability`, not just `#available`.
Hardware eligibility, settings, downloaded assets, locale, and region
can matter. Recheck prompts and expected quality as model versions
change.[^intelligence]

Do not promise that all inference is local merely because an Apple
framework is used. Inspect the chosen model/provider and current API:
local, Apple-hosted, and other remote execution have different data
flows. Explain those flows in privacy disclosures when applicable.
Provide useful behavior when the model is unavailable.[^intelligence]

Treat generated output as untrusted. Validate structured results before
using them, and preserve normal authorization for model-triggered tools.
Require user control for consequential actions. Prefer a deterministic
API or ordinary code when it solves the problem more reliably.

## Specialized lookup routes

For features outside the map, start with Apple's documentation catalogue
and current entitlement rules. Examples include payments and identity,
accessory protocols, network/system extensions, professional media,
games, and specialized hardware. Do not add restricted capabilities
without confirming eligibility and distribution support.[^catalog]

[^catalog]: [Apple Developer Documentation](https://developer.apple.com/documentation/); [Entitlements](https://developer.apple.com/documentation/bundleresources/entitlements).
[^integration]: [App Intents](https://developer.apple.com/documentation/appintents); [Core Spotlight](https://developer.apple.com/documentation/corespotlight); [NSUserActivity](https://developer.apple.com/documentation/foundation/nsuseractivity); [Universal links](https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app).
[^widgets]: [WidgetKit](https://developer.apple.com/documentation/widgetkit); [Keeping widgets current](https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date); [ActivityKit](https://developer.apple.com/documentation/activitykit).
[^groups]: [App Groups entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.application-groups); [Apple Developer Documentation](https://developer.apple.com/documentation/).
[^media]: [AVKit](https://developer.apple.com/documentation/avkit); [AVFoundation](https://developer.apple.com/documentation/avfoundation); [PhotosUI](https://developer.apple.com/documentation/photosui); [PDFKit](https://developer.apple.com/documentation/pdfkit); [WebKit](https://developer.apple.com/documentation/webkit); [Core Image](https://developer.apple.com/documentation/coreimage); [Metal](https://developer.apple.com/documentation/metal); [ScreenCaptureKit](https://developer.apple.com/documentation/screencapturekit).
[^device]: [MapKit](https://developer.apple.com/documentation/mapkit); [Core Location](https://developer.apple.com/documentation/corelocation); [Core Bluetooth](https://developer.apple.com/documentation/corebluetooth); [Core Motion](https://developer.apple.com/documentation/coremotion); [HealthKit](https://developer.apple.com/documentation/healthkit); [HomeKit](https://developer.apple.com/documentation/homekit); [GameKit](https://developer.apple.com/documentation/gamekit).
[^intelligence]: [Core ML](https://developer.apple.com/documentation/coreml); [Vision](https://developer.apple.com/documentation/vision); [Natural Language](https://developer.apple.com/documentation/naturallanguage); [Speech](https://developer.apple.com/documentation/speech); [Foundation Models](https://developer.apple.com/documentation/foundationmodels); [SystemLanguageModel](https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel).
