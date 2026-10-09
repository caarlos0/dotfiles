# Privacy, permissions, and trust

## Keep the layers separate

| Layer | Purpose | Does not replace |
|---|---|---|
| Entitlement/capability | Signed access to a platform capability | User authorization |
| Purpose string | Explains protected-resource use | Permission handling |
| Authorization API | Reports/requests resource-specific consent | App Store disclosure |
| ATT | Consent for tracking under Apple's definition | All other privacy obligations |
| Privacy manifest | Declares covered data/API/tracking use | Consent or published privacy answers |
| App privacy answers | App Store disclosure of collection | SDK inventory or privacy policy |
| Privacy policy | Explains actual practices and rights | Correct implementation |

Check each resource separately. Not every permission needs the same
entitlement, and no entitlement grants all user consent.
ATT covers tracking, not only reading an advertising identifier.
Use `ATTrackingManager`, not deprecated advertising tracking flags,
when ATT applies.[^permissions][^att]

## Request the least access needed

Ask at the point where the person uses the feature. Provide specific,
localized purpose strings and a usable denied-access path. Prefer system
selection APIs such as photo or document pickers if selected items are
enough; do not ask for a full library by default.[^pickers]

Handle each framework's not-determined, denied, restricted, authorized,
and limited states where present. Location precision and authorization
duration are separate concerns. Observe or recheck authorization as
appropriate when it changes; a cached initial grant is not permanent.
Do not repeatedly request a permission the person has denied.[^permissions]

## Keep disclosures consistent with the binary

Inventory the app's code, extensions, dependencies, network destinations,
analytics, advertising, and remote providers. Reconcile actual data use
with `PrivacyInfo.xcprivacy`, approved required-reason declarations,
App Store privacy answers, and the privacy policy.[^disclosure]

Consult Apple's current required-reason API categories and SDK list.
SDK manifest and signature requirements are conditional, including SDK
identity, packaging, and the current submission rules. Do not claim
every source dependency must carry a binary signature, or that any
approved reason is valid for any use of an API.[^sdk]

Xcode's generated privacy report assists the review; it does not
automatically publish correct App Store Connect answers. Include
collection by third-party SDKs, not just calls written by the app team.
Keep the privacy policy accessible in the app and store metadata.[^disclosure]

## Account and login obligations

Check current Guideline 5.1.1: apps that support account creation must
offer account deletion in the app, not only deactivation. Explain
subscription cancellation separately; deleting an app account does not
itself cancel App Store billing.[^accounts]

Guideline 4.8 concerns third-party/social login used for the primary
account. Check its privacy-equivalent login criteria and exceptions
before prescribing Sign in with Apple. Proprietary-only login and
certain institutional or service-client models have exceptions.
Do not force an account on an app without significant account-based
features.[^accounts]

## Protect data and boundaries

Store appropriate small secrets in Keychain, not UserDefaults, source,
logs, or analytics. Choose accessibility, synchronization, and sharing
attributes from the threat model and locked-device behavior.
Use platform file protection for sensitive files and handle unavailable
protected data during background work.[^storage]

Keep ATS and system TLS trust evaluation. Avoid global cleartext
exceptions or unconditional certificate acceptance. Network framework
and lower-level transports need their own correctly configured trust
and protocol behavior; do not assume all traffic gets URLSession's
ATS policy.[^network]

Use explicit privacy treatment for log fields. Do not assume every
interpolated value is private, and do not log secrets even with redaction
as a justification. Keep diagnostics useful without user payloads.[^logs]

For Mac files, distinguish sandbox entitlements, user-selected access,
security-scoped bookmarks, and resource privacy prompts. Balance only
the explicit scope access the code successfully starts. Hardened Runtime
and App Sandbox solve different problems; neither grants permission to
protected resources by itself.[^mac]

Validate universal-link and custom-scheme input before routing. Domain
association does not make URL parameters trusted. Require normal
authorization and user confirmation for sensitive actions rather than
allowing a link to delete data or bypass an account boundary.[^links]

## Review checks

- Denied or limited access does not crash, loop, or block unrelated work.
- Purpose strings describe the actual feature.
- Data collection matches disclosures, including dependency changes.
- Login/deletion behavior matches the applicable guideline.
- Secrets and private payloads stay out of source and diagnostics.
- Sandbox and Hardened Runtime exceptions are narrowly justified.
- Malformed links and unauthorized actions fail safely and visibly.

Do not treat this checklist as a legal opinion or a complete security
audit. For regulated data, children, or region-dependent requirements,
verify the applicable policy and obtain qualified review where needed.

[^permissions]: [Protecting privacy](https://developer.apple.com/documentation/uikit/protecting-the-user-s-privacy); [Protected resources](https://developer.apple.com/documentation/uikit/requesting-access-to-protected-resources); [Entitlements](https://developer.apple.com/documentation/bundleresources/entitlements).
[^att]: [App Tracking Transparency](https://developer.apple.com/documentation/apptrackingtransparency); [Deprecated tracking flag](https://developer.apple.com/documentation/adsupport/asidentifiermanager/isadvertisingtrackingenabled).
[^pickers]: [Photo selection](https://developer.apple.com/documentation/photokit/selecting-photos-and-videos-in-ios); [App Review Guidelines, 5.1.1](https://developer.apple.com/app-store/review/guidelines/).
[^disclosure]: [Privacy manifests](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files); [Describing data use](https://developer.apple.com/documentation/bundleresources/describing-data-use-in-privacy-manifests); [App privacy details](https://developer.apple.com/app-store/app-privacy-details/); [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).
[^sdk]: [Required-reason APIs](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api); [SDK requirements](https://developer.apple.com/support/third-party-SDK-requirements/).
[^accounts]: [App Review Guidelines, 4.8 and 5.1.1](https://developer.apple.com/app-store/review/guidelines/); [Account deletion](https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion).
[^storage]: [Keychain](https://developer.apple.com/documentation/security/keychain-services); [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults); [File protection](https://developer.apple.com/documentation/uikit/encrypting-your-app-s-files).
[^network]: [Preventing insecure connections](https://developer.apple.com/documentation/security/preventing-insecure-network-connections).
[^logs]: [Logging](https://developer.apple.com/documentation/os/logging).
[^mac]: [Sandbox file access](https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox); [Hardened Runtime](https://developer.apple.com/documentation/security/hardened-runtime).
[^links]: [Universal links](https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app).
