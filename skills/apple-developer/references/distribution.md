# Signing, StoreKit, and distribution

## Select the channel before release engineering

| Channel | Main obligations |
|---|---|
| App Store / Mac App Store | Correct signing, metadata, App Review, applicable commerce/privacy rules |
| TestFlight | Uploaded build, tester access, applicable beta review, expiry |
| Mac direct distribution | Developer ID workflow, Hardened Runtime, notarization, delivery validation |
| Other eligible distribution | Current region/program eligibility, agreements, signing/review rules |

Mac App Store apps require App Sandbox. Direct Mac distribution does
not inherently require App Sandbox. Hardened Runtime and notarization
are separate from sandboxing. Notarization is not App Review and does
not certify UX or compliance with App Store business rules.[^channels]

For direct Mac releases, use current `notarytool` workflows, inspect
failure logs, staple tickets where supported, and verify the delivered
artifact. Do not bypass Gatekeeper to declare distribution successful.
Do not upload credentials or submit builds without authorization.[^notary]

## Treat purchases as a state machine

Use StoreKit's product and transaction APIs rather than granting access
from a button click or an unverified transaction.

```text
Purchase result
  user cancelled -> no grant; return to usable UI
  pending        -> explain pending; await later transaction updates
  success        -> verify transaction
                      unverified -> no grant; report/recover
                      verified   -> deliver or persist valid entitlement
                                    then finish the transaction
```

Handle thrown purchase errors separately from ordinary cancellation.
Start an owned transaction-update listener early and process unfinished
work. Current purchase results and transaction updates are complementary
entry points; use a shared delivery path with idempotent effects.
Finish only after delivering the content or enabling the service.[^purchase]

Reconcile `Transaction.currentEntitlements` for applicable products.
It is not a consumable balance ledger, and non-renewing subscriptions
need their own validity interpretation. Reflect expiration, revocation,
refunds, and subscription status instead of persisting an eternal
`isPremium = true` flag.[^entitlements]

Use `AppStore.sync()` for an explicit user-requested restore when needed,
not as an automatic launch-time refresh; it can prompt for authentication.
Normal entitlement reconciliation should not force repeated sign-in
prompts.[^restore]

Add a backend when the product needs server-side access decisions or
cross-platform entitlements, not by default for every purchase.
Verify signed server data with supported libraries. Deduplicate server
notifications using their notification identity and reconcile missed or
out-of-order lifecycle information through supported APIs.
Distinguish subscription cancellation, billing retry, grace period,
expiration, and revocation.[^server]

Test success, pending/Ask to Buy, user cancellation, verification failure,
interrupted delivery, restore, renewal, expiration, grace/retry, refund,
and revocation as applicable. Use StoreKit configuration tests and the
App Store sandbox; local configuration, sandbox, TestFlight, and
production are distinct environments.[^storetests]

## Avoid the common review failures

Before submission:

- Provide working review access: demo account or full demo mode, live
  backend, and instructions for non-obvious features or hardware.
- Match screenshots, descriptions, age-rating answers, and privacy
  disclosures to the submitted build.
- Supply specific purpose strings and a denied-permission experience.
- Provide in-app account deletion when account creation is supported.
- Evaluate Guideline 4.8 login criteria and exceptions.
- Explain purchase value, price, subscription terms, and restore path.
- Check applicable rules for user-generated content, children,
  regulated services, and sensitive data rather than assuming a
  general-purpose app checklist is sufficient.[^review]

## Payment rules depend on the product and storefront

Guideline 3.1 distinguishes digital features, physical goods/services,
reader apps, and other business models. External purchase links and
alternative payments have storefront- and program-specific conditions.
Do not say either "all digital goods always require IAP" or "external
payments are now allowed everywhere."[^payments]

Before giving release advice, check the current guidelines and the
applicable Apple program terms. Confirm storefront, app category,
entitlement, OS/API support, disclosure UI, reporting obligations, and
fees. Device language or the developer's home country is not a substitute
for storefront eligibility. Do not freeze commissions, deadlines, or
regional legal outcomes into code without a current requirement.[^payments]

## Release checklist

1. Confirm current SDK submission rules separately from minimum
   deployment targets, and confirm team agreements and permissions.
2. Build/archive the intended scheme with the correct bundle IDs,
   versions, signing, entitlements, extensions, and dependencies.
3. Validate the archive, preserve matching dSYMs, and test the actual
   distribution artifact.
4. Check StoreKit, privacy manifests, SDK requirements, metadata,
   account flows, and review access.
5. Use TestFlight as appropriate; check current tester and build-expiry
   limits rather than treating them as permanent constants.
6. Submit only with authorization. Choose release timing and phased
   rollout deliberately.
7. Watch crashes, hangs, purchase failures, and relevant support signals.
   Keep a forward-fix plan.[^release]

Phased release limits automatic updates, not manual downloads. Pausing
does not downgrade existing installations. App Store distribution has
no general instant rollback to an older binary: ship a corrected version.
Removing an app from sale does not restore old code on users' devices.
Use backward-compatible data and server changes accordingly.[^phased]

[^channels]: [Distribution](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases); [App Sandbox](https://developer.apple.com/documentation/security/app-sandbox); [Hardened Runtime](https://developer.apple.com/documentation/security/hardened-runtime).
[^notary]: [Notarizing Mac software](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution).
[^purchase]: [PurchaseResult](https://developer.apple.com/documentation/storekit/product/purchaseresult); [Transaction updates](https://developer.apple.com/documentation/storekit/transaction/updates); [Unfinished transactions](https://developer.apple.com/documentation/storekit/transaction/unfinished); [Finishing transactions](https://developer.apple.com/documentation/storekit/transaction/finish()).
[^entitlements]: [Current entitlements](https://developer.apple.com/documentation/storekit/transaction/currententitlements).
[^restore]: [AppStore.sync()](https://developer.apple.com/documentation/storekit/appstore/sync()).
[^server]: [VerificationResult](https://developer.apple.com/documentation/storekit/verificationresult); [Server notification payload](https://developer.apple.com/documentation/appstoreservernotifications/responsebodyv2decodedpayload); [Notification types](https://developer.apple.com/documentation/appstoreservernotifications/notificationtype).
[^storetests]: [StoreKit testing in Xcode](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode); [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview).
[^review]: [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/); [Account deletion](https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion).
[^payments]: [App Review Guidelines, 3.1](https://developer.apple.com/app-store/review/guidelines/); [EU distribution](https://developer.apple.com/support/apps-in-the-eu/); [Reader apps](https://developer.apple.com/support/reader-apps/); [External purchases](https://developer.apple.com/documentation/storekit/external-purchase).
[^release]: [Submission requirements](https://developer.apple.com/app-store/submitting/); [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview); [App Store Connect roles](https://developer.apple.com/help/app-store-connect/manage-your-team/overview-of-accounts-and-roles); [SDK requirements](https://developer.apple.com/support/third-party-SDK-requirements/).
[^phased]: [Phased release](https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-update-in-phases).
