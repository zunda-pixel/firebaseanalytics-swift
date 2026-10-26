# firebaseanalytics-swift

> [!IMPORTANT]
> This project is under development

Firebase Analytics Client for Swift.

```swift
let clientInformation: ClientInformation = .init(
  os: "ios",
  osVersion: "18.3",
  deviceModel: "iPhone17,3",
  locale: "ja-jp",
  timeZoneOffsetMinutes: 540,
  installMethod: "manual_install",
  bundleId: "com.apple.SampleApp",
  appVersion: "1.0",
  googleAppId: "1:21332412389:ios:11681asd2a3cd5d8"
)

let session: Session = .init(
  firstOpenAfterInstall: true,
  firstOpenTime: 1_737_550_800_000,
  nonPersonalizedAds: false,
  sessionId: 1_737_555_666,
  sessionNumber: 2,
  lifetimeEngagement: 1_175_666,
  sessionEngagement: 10055,
  userId: "user-id"
)

let nowMillis = UInt(Date.now.timeIntervalSince1970 * 1000)

let payload = Payload(
  events: [
    EventPayload(
      eventName: "login",
      parameters: [
        .method: "Google",
        .platform: "app",
      ],
      previousTimestampMillis: nowMillis,
      timestampMillis: nowMillis
    ),
    EventPayload(
      eventName: "_e",
      parameters: [
        "_et": .uint(891),
        .platform: "auto"
      ],
      previousTimestampMillis: nowMillis,
      timestampMillis: nowMillis
    ),
  ],
  userAttributes: session.parameters,
  uploadTimestampMillis: nowMillis,
  startTimestampMillis: nowMillis,
  endTimestampMillis: nowMillis,
  previousBundleEndTimestampMillis: nowMillis,
  os: clientInformation.os,
  osVersion: clientInformation.osVersion,
  deviceModel: clientInformation.deviceModel,
  userDefaultLanguage: clientInformation.locale,
  timeZoneOffsetMinutes: clientInformation.timeZoneOffsetMinutes,
  installMethod: clientInformation.installMethod,
  bundleId: clientInformation.bundleId,
  appVersion: clientInformation.appVersion,
  gmpVersion: 110700,
  uploadingGmpVersion: 110700,
  appInstanceId: "BC75E87831231231B7A179248F24080C",
  bundleSequentialIndex: 25, // count up per bundle
  googleAppId: clientInformation.googleAppId,
  previousBundleStartTimestampMillis: nowMillis,
  vendorDeviceId: "CAIIJF38-E407-4954-BC16-F693A22F9FA9", // IDFV
  firebaseInstanceId: "d4Xw8qsfsadBoMYlsYHnot",
  appVersionMajor: 1,
  configVersion: 1_727_127_969_769_945,
  experimentIds: [42_820_019],
  consentSignals: ConsentSettings().consentSignals, // "G1--"
  redactedFields: ["google_signals"],
  consentDiagnostics: "19911",
  isDMARegion: false,
  deliveryIndex: 13 // count up per delivery
)

let analytics = Analytics(
  httpClient: .urlSession(.shared),
  userAgent: "SampleApp/1 CFNetwork/3826.400.120 Darwin/24.3.0",
  clientInformation: clientInformation,
  session: session
)

try await analytics.log(payload: payload)
```
