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
  localeId: 540,
  installMethod: "manual_install",
  bundleId: "com.apple.SampleApp",
  appVersion: "1.0",
  googleAppId: "1:21332412389:ios:11681asd2a3cd5d8"
)

let session: Session = .init(
  firstInteraction: false,
  firstOpenTime: 1_737_550_800_666,
  nonPersonalizedAds: false,
  sessionId: 1_737_555_666,
  sessionNumber: 2,
  lifetimeEngagement: 1_175_666,
  sessionEngagement: 10055,
  userId: "user-id"
)

let payload = Payload(
  value: 1,
  events: [
    EventPayload(
      eventName: "login",
      parameters: [
        .method: "Google",
        .platform: "app",
      ],
      previousTimestampMillis: UInt(Date.now.timeIntervalSince1970 * 100),
      timestampMillis: UInt(Date.now.timeIntervalSince1970 * 100)
    ),
    EventPayload(
      eventName: "_e",
      parameters: [
        "_et": .uint(891),
        .platform: "auto"
      ],
      previousTimestampMillis: UInt(Date.now.timeIntervalSince1970 * 100),
      timestampMillis: UInt(Date.now.timeIntervalSince1970 * 100)
    ),
  ],
  sessionInformations: session.parameters,
  value4: UInt(Date.now.timeIntervalSince1970 * 100), // upload_timestamp_millis
  value5: UInt(Date.now.timeIntervalSince1970 * 100), // start_timestamp_millis
  value6: UInt(Date.now.timeIntervalSince1970 * 100), // end_timestamp_millis
  value7: UInt(Date.now.timeIntervalSince1970 * 100), // previous_bundle_end_timestamp_millis
  os: clientInformation.os,
  osVersion: clientInformation.osVersion,
  deviceModel: clientInformation.deviceModel,
  value11: clientInformation.locale,
  value12: clientInformation.localeId,
  installMethod: clientInformation.installMethod,
  bundleId: clientInformation.bundleId,
  appVersion: clientInformation.appVersion,
  value17: 110700, // gmp_version
  value18: 110700, // uploading_gmp_version
  value21: "BC75E87831231231B7A179248F24080C",  // fix // app_instance_id
  value23: 25,  // count up // bundle_sequential_index
  googleAppId: clientInformation.googleAppId,
  value26: UInt(Date.now.timeIntervalSince1970 * 100),  // free // previous_bundle_start_timestamp_millis
  value27: "CAIIJF38-E407-4954-BC16-F693A22F9FA9",  // fix // resettable_device_id
  value30: "d4Xw8qsfsadBoMYlsYHnot",  // fix // firebase_instance_id
  value31: 1, // app_version_major
  value35: 1_727_127_969_769_945,  // fix // config_version
  value45: 42_820_019,  // fix
  value52: "G1--",  // fix // consent_signals
  value64: "google_signals",  // fix
  value71: "19911",  // fix // consent_diagnostics
  value72: 0,  // fix
  value77: 13  // count up
)

let analytics = Analytics(
  httpClient: .urlSession(.shared),
  userAgent: "SampleApp/1 CFNetwork/3826.400.120 Darwin/24.3.0",
  clientInformation: clientInformation,
  session: session
)

try await analytics.log(payload: payload)
```
