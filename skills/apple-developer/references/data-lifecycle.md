# Data, documents, networking, and background work

## Choose storage from the data contract

| Need | Starting point | Main check |
|---|---|---|
| Small non-sensitive settings | UserDefaults | Not secrets or a database |
| Tokens, passwords, cryptographic keys | Keychain | Accessibility and sharing policy |
| Structured app data | SwiftData or Core Data | Queries, migrations, target support |
| User-owned files/documents | Document APIs and files | Save, coordination, undo, access |
| Cloud-synced records | CloudKit or framework integration | Schema, conflicts, accounts, deletion |
| Large media/cache data | Appropriate file storage | Lifetime, quotas, regeneration |

Prefer the existing persistence stack when it meets the requirement.
SwiftData uses Core Data technology but is not an instruction to migrate
every Core Data app. Check the exact features and deployment targets
required by the model.[^storage]

Keep framework contexts in their required execution domain. Use Core
Data context scheduling APIs and SwiftData's supported isolation tools.
An arbitrary actor around a context is not proof that cross-context
objects are safe to share.[^contexts]

## Preserve stores across upgrades

Keep versioned schemas and supported migration paths. Test opening
representative stores from shipped versions, including skipped app
updates, large stores, and malformed or unavailable data. Verify the
resulting values and relationships, not just that opening succeeds.
SwiftData provides `SchemaMigrationPlan`; use Core Data migration
mechanisms for Core Data stores.[^migration]

Surface save and migration errors. Do not fix initialization failure by
deleting the store or silently replacing it with an in-memory database.
Test interruption and recovery, but do not invent a backup/retry layer
merely because a framework document omits an implementation detail.
Choose export, recovery, and backup features from actual data-loss risk.

## Cloud sync is a separate design

CloudKit-backed models have schema restrictions, including unsupported
unique constraints and required relationships in Core Data mirroring.
Configure the required container and capabilities. Follow deployment
rules for the production schema before shipping it.[^cloud]

Do not assume every CloudKit integration supports the same private,
public, or shared database behavior. Core Data supports documented
sharing flows; SwiftData integration and direct CloudKit APIs have
different surfaces. Verify the specific path instead of applying a
framework-wide rule.[^cloud]

Define offline behavior, conflict outcomes, deletion propagation, and
sign-out/account-change behavior. Sync can propagate an unwanted write
or deletion; it is not a substitute for an app's recovery policy.
Test two devices editing offline and reconnecting, not just one device
round-tripping to the cloud.

## Respect document ownership and access

Use the document stack appropriate to the project, such as
`DocumentGroup`, `FileDocument`/`ReferenceFileDocument`, `UIDocument`,
or `NSDocument`, after checking the current SDK contract.
Use coordinated access where documents are shared with file presenters,
other processes, or cloud file providers.[^documents]

Distinguish implicitly granted panel access from URLs that require
explicit security-scoped access. For a successful explicit
`startAccessingSecurityScopedResource()`, balance the corresponding
`stopAccessingSecurityScopedResource()` when done. Handle stale
bookmarks and changed permissions. Do not stop access unconditionally
for every URL.[^files]

## Networking

Use `URLSession` for ordinary HTTP/HTTPS work. Consider Network framework
for lower-level transport requirements; choose from the actual protocol
and platform documentation rather than replacing networking by habit.
Preserve system trust evaluation and ATS protection.[^network]

Treat cancellation, connectivity failure, server rejection, and decoding
failure as different results. Use protocol caching and bounded work
where suitable. Add retries only for demonstrated transient failures
and operations whose semantics permit retry; do not duplicate writes
because a response was lost.

## Background execution is not an always-running service

| Requirement | Candidate | Constraint |
|---|---|---|
| Deferred refresh/processing | BGTaskScheduler on supported targets | System chooses execution time |
| Continue user-started work | BGContinuedProcessingTask where available | User-visible progress and cancellation |
| Long network transfer | Background URLSession | Transfer/session rules, not arbitrary compute |
| Background change notification | APNs background push | Best effort, can be delayed or dropped |
| Mac in-process maintenance | NSBackgroundActivityScheduler | App lifecycle and energy scheduling |
| Mac login helper/service | SMAppService when genuinely needed | Explicit product need and user control |

Do not promise exact execution from `earliestBeginDate`, timers, silent
pushes, or periodic scheduling. Register handlers as required, complete
tasks correctly, and use expiration handlers to cancel and checkpoint
work. BackgroundTasks and native macOS scheduling are not interchangeable
APIs.[^background]

A background URL session can continue transfers while an app is
suspended or system-terminated. A user force-quit, including swipe-to-kill
on iOS, cancels background tasks; do not claim they reliably continue.
Reconcile state on the next launch without assuming automatic retry.
Background upload and download requirements also differ from ordinary
in-process requests; check the specific task API.[^transfers]

## Validation cases

Select cases relevant to the change: offline and metered networks,
low power, permission revocation, locked protected data, suspended app,
system termination, force-quit, task expiration, duplicate delivery,
multiple scenes, account changes, migration from old stores, and cloud
conflicts. Assert user data and visible states after recovery.

[^storage]: [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults); [Keychain](https://developer.apple.com/documentation/security/keychain-services); [SwiftData](https://developer.apple.com/documentation/swiftdata).
[^contexts]: [Core Data](https://developer.apple.com/documentation/coredata); [SwiftData](https://developer.apple.com/documentation/swiftdata).
[^migration]: [SchemaMigrationPlan](https://developer.apple.com/documentation/swiftdata/schemamigrationplan); [Core Data](https://developer.apple.com/documentation/coredata).
[^cloud]: [SwiftData sync](https://developer.apple.com/documentation/swiftdata/syncing-model-data-across-a-persons-devices); [Core Data mirroring](https://developer.apple.com/documentation/coredata/mirroring-a-core-data-store-with-cloudkit); [Sharing Core Data objects](https://developer.apple.com/documentation/coredata/sharing-core-data-objects-between-icloud-users).
[^documents]: [DocumentGroup](https://developer.apple.com/documentation/swiftui/documentgroup); [NSFileCoordinator](https://developer.apple.com/documentation/foundation/nsfilecoordinator).
[^files]: [Sandbox file access](https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox); [NSOpenPanel](https://developer.apple.com/documentation/appkit/nsopenpanel); [Starting scoped access](https://developer.apple.com/documentation/foundation/url/startaccessingsecurityscopedresource()).
[^network]: [Choosing a networking API](https://developer.apple.com/documentation/technotes/tn3151-choosing-the-right-networking-api); [Preventing insecure connections](https://developer.apple.com/documentation/security/preventing-insecure-network-connections).
[^background]: [BackgroundTasks](https://developer.apple.com/documentation/backgroundtasks); [Continued processing](https://developer.apple.com/documentation/backgroundtasks/bgcontinuedprocessingtask); [Background activity scheduler](https://developer.apple.com/documentation/foundation/nsbackgroundactivityscheduler); [SMAppService](https://developer.apple.com/documentation/servicemanagement/smappservice).
[^transfers]: [URL Loading System](https://developer.apple.com/documentation/foundation/url-loading-system); [Background cancellation reasons](https://developer.apple.com/documentation/foundation/url-session-background-task-cancellation-reasons).
