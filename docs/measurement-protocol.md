# Measurement protocol

Upload payload of Firebase Analytics for iOS (`POST https://app-analytics-services.com/a`, gzip).

## Source

- `GoogleAppMeasurement` 13.0.1 (`https://dl.google.com/firebase/ios/swiftpm/13.0.1/GoogleAppMeasurement.zip`,
  sha256 `0b114252276729a5ac2d169e95935c08a79764d0f533863857633b70fb42a922`, the version pinned by `firebase-ios-sdk` `Package.swift`), `ios-arm64` slice.
- The static archive was opened in Anatomy.app and the objects were inspected with `otool` / `llvm-objdump`.

## How field numbers and names were derived

1. `gmp_measurement.pb.o` contains nanopb field tables (`appmeasurement_*_fields`).
   Each 32-byte entry is `tag, type, data_offset, size_offset, data_size, array_size, ptr`,
   which gives the exact field number, wire type, scalar width and sub-message of every field.
2. The SDK sets fields through `NANOSet*(message, index, value)`, where `index` is a slot of the
   message info, not the field number. `apmpb_set_measurement_bundle_encoders` copies slot `n`
   into the nanopb struct, so slot → struct offset → field number can be resolved.
3. Every `NANOSet*` call site in `APMMeasurement*` was then read to see what value is written
   (`timeZoneOffsetMinutes`, `identifierForVendor`, `isDMARegion`, …).

## MeasurementBatch

| # | Type | Meaning |
|---|------|---------|
| 1 | repeated MeasurementBundle | bundles |
| 7 | string | |
| 8 | string | upload subdomain (sGTM) |
| 9 | uint32 | upload source |

## MeasurementBundle

| # | Type | Swift (`Payload`) | Set from |
|---|------|-------------------|----------|
| 1 | int32 | `protocolVersion` | `APMMeasurementProtocolVersion` (= 1) |
| 2 | repeated Event | `events` | |
| 3 | repeated UserAttribute | `userAttributes` | |
| 4 | int64 | `uploadTimestampMillis` | `-[APMMeasurement uploadData]` |
| 5 | int64 | `startTimestampMillis` | bundle start (`seconds * 1000`) |
| 6 | int64 | `endTimestampMillis` | bundle end (`seconds * 1000`) |
| 7 | int64 | `previousBundleEndTimestampMillis` | `lastBundleEndTimestamp` |
| 8 | string | `os` | `APMMeasurementPlatform` (= `"ios"`) |
| 9 | string | `osVersion` | `deviceOSVersion` |
| 10 | string | `deviceModel` | `deviceModel` |
| 11 | string | `userDefaultLanguage` | `userDefaultLanguage` |
| 12 | int32 | `timeZoneOffsetMinutes` | `timeZoneOffsetMinutes` |
| 13 | string | `installMethod` | `APMMeasurementManualInstall` (= `"manual_install"`) / App Store |
| 14 | string | `bundleId` | `-[NSBundle bundleIdentifier]` |
| 15 | int64 | – | |
| 16 | string | `appVersion` | `identity.appVersion` |
| 17 | int64 | `gmpVersion` | `appMeasurementLibraryVersion` |
| 18 | int64 | `uploadingGmpVersion` | `appMeasurementLibraryVersion` at upload |
| 19 | string | `resettableDeviceId` | `resettableDeviceID` (IDFA) |
| 20 | bool | `limitedAdTracking` | `hasLimitedAdTracking` |
| 21 | string | `appInstanceId` | `appInstanceID` |
| 22 | int64 | – | |
| 23 | int32 | `bundleSequentialIndex` | `lastBundleIndex` |
| 24 | string | `healthMonitor` | `monitoringDataForDispatch…` |
| 25 | string | `googleAppId` | `appIDFromGMP` |
| 26 | int64 | `previousBundleStartTimestampMillis` | `lastBundleStartTimestamp` |
| 27 | string | `vendorDeviceId` | `identifierForVendor` (IDFV) |
| 28 | bool | – | |
| 29 | repeated AudienceLeafFilterResult | – | audience evaluation results |
| 30 | string | `firebaseInstanceId` | `firebaseInstallationID` |
| 31 | int32 | `appVersionMajor` | `appVersionMajor` |
| 32 | int32 | `appVersionMinor` | `appVersionMinor` |
| 33 | int32 | `appVersionRelease` | `appVersionRelease` |
| 34 | string | – | |
| 35 | int64 | `configVersion` | remote config `version` |
| 39 | int32 | `retryCount` | DB column `retry_count` |
| 41 | string | – | |
| 45 | repeated uint64 (not packed) | `experimentIds` | remote config `experimentIDs` |
| 47 | int64 | – | `apm_64LSBMD5` checksum (when `checksumEnabled`) |
| 50 | string | – | |
| 52 | string | `consentSignals` | `+[APMConsentSettingsUtil consentSignals]` |
| 53 | uint32 | `appleConsentStatus` | `appleConsentStatus` (ATT) |
| 55 | bool | – | |
| 59 | HashedUserData | – | |
| 63 | string | `sessionStitchingToken` | `sessionStitchingTokenWithSessionNumber:…` |
| 64 | repeated string | `redactedFields` | data controls |
| 65 | string | `ephemeralAppInstanceId` | `ephemeralAppInstanceID` |
| 67 | int64 | – | |
| 71 | string | `consentDiagnostics` | `+[APMConsentSettingsUtil consentDiagnostics]` |
| 72 | bool | `isDMARegion` | `isDMARegion` |
| 73 | string | `corePlatformServices` | `corePlatformServices` joined, `"-"` when empty |
| 75 | string | – | |
| 77 | int32 | `deliveryIndex` | `lastDeliveryIndex` |
| 79 | AdCampaignInfo | – | `adCampaignInfoBuffer` |
| 84 | OnDeviceMeasurementInfo | – | |
| 86 | ConsentInfoExtra | – | |
| 87 | int32 | `sdkCapabilities` | consent status availability and linked libraries; see below |
| 89 | repeated DiagnosticSignal | – | |
| 91 | int64 | `sbtMicros` | signed microsecond value; clock origin unconfirmed |

## Event

| # | Type | Meaning |
|---|------|---------|
| 1 | repeated EventParam | params |
| 2 | string | name |
| 3 | int64 | timestamp millis |
| 4 | int64 | previous timestamp millis |
| 5 | int32 | |
| 6 | int64 | |
| 7 | int64 | |

## EventParam

| # | Type | Meaning |
|---|------|---------|
| 1 | string | name |
| 2 | string | string value |
| 3 | int64 | int value |
| 4 | float (fixed32) | float value |
| 5 | double (fixed64) | double value |
| 6 | repeated EventParam | nested value (e.g. `items`) |

Array elements (e.g. one item of `items`) are `EventParam` without name whose field 6 holds the item's params.

## UserAttribute

| # | Type | Meaning |
|---|------|---------|
| 1 | int64 | set timestamp millis |
| 2 | string | name |
| 3 | string | string value |
| 4 | int64 | int value |
| 5 | float (fixed32) | float value |
| 6 | double (fixed64) | double value |

Internal user property names (`APMUserPropertyNames+Internal`):

| Name | Long name |
|------|-----------|
| `_fot` | `first_open_time` |
| `_fi` | `first_open_after_install` |
| `_id` | `user_id` |
| `_lte` | `lifetime_user_engagement` |
| `_se` | `session_user_engagement` |
| `_sid` | `ga_session_id` |
| `_sno` | `ga_session_number` |
| `_ln` | `firebase_last_notification` |
| `_lair` | `last_advertising_id_reset` |
| `_ldl` | `last_deep_link_referrer` |

## Consent strings

- `consentSignals` (52): `"G1"` + `APMConsentBitV1(ad_storage)` + `APMConsentBitV1(analytics_storage)`,
  where granted = `"1"`, denied = `"0"`, not set = `"-"`.
- `consentDiagnostics` (71): `"1"` + one `%d` digit per consent type in the order
  `ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`.
  The digit is the diagnostic source of the value (`9` when the consent type has no value, `0` after reset).


## Follow-up analysis: consent sources and SDK metadata

All addresses below are object-relative ARM64 virtual addresses in the pinned 13.0.1
archive, not addresses in a linked application. See [reproduction steps](reproduce-analysis.sh).
Anatomy was used to inspect the archive member and symbol tables, then the extracted
`APMConsentSettingsUtil.o` was opened directly and its Disassembly address set to `14c`.
Opening the object directly avoids the archive view's inability to map this member's
file offset to a disassembly address.

### Consent diagnostic sources

`APMDiagnosticSourceFromConsentSource` at `0x14c–0x1a0` compares the source with
5, 10, 20, 30 and 40 and returns:

| Internal consent source | Diagnostic digit |
|---|---|
| 5 | 7 |
| 10 or 30 | 5 |
| 20 | 3 |
| 40 | 4 |
| anything else | 0 |

`ConsentSettings.DiagnosticSource(consentSource:)` implements this conversion.
These internal source values are **not** wire digits. Their human-readable origin names
have not been established, so the API deliberately does not guess names such as API/manifest.

`+[APMConsentSettingsUtil refreshDiagnosticSources:]` (`0x2580`) also assigns:

- 1: a default setting exists and the consent type does not have the regional suffix
  (`0x26e4–0x2720`, branch to `0x2768`).
- 2: a delegated `ad_personalization` setting exists (`0x26a4–0x26e0`).
- 8: `APMShouldApplyRegionalConsent` returns true (`0x2784–0x27bc`).
- 9: no applicable value (`0x2724–0x274c`).

The helper encodes caller-supplied, resolved statuses and sources. It does not reproduce
Firebase's persistent consent state, remote default/delegation resolution or regional
eligibility evaluation. In particular, pass a resolved status along with `.defaultSetting`
or `.delegated`; passing nil still encodes 9 in this stateless helper.

### Bundle field 87

`APMMeasurement+Event.o`, `0x396c–0x39ec`, builds an OR mask:

| Mask | SDK predicate | Swift option |
|---|---|---|
| 1 | `hasAppDataConsentStatus` | `.appDataConsentStatus` |
| 2 | `isAPMPrivateSetMembershipClientLinked` | `.privateSetMembership` |
| 4 | `isAlphaAppAdsOnDeviceConversionLinked` | `.alphaAppAdsOnDeviceConversion` |
| 8 | `isGoogleAdsOnDeviceConversionLinked` | `.googleAdsOnDeviceConversion` |

Bit 0 indicates availability of a status, **not whether consent was granted**.
The result is set through `NANOSetInt32(bundle, 55, mask)`.
`apmpb_measurement_bundle_encoder.o` at `0x5b4–0x5c8` reads slot 55
(pointer offset `0x1b8`) and writes nanopb data offset `0x55c`, corresponding to tag 87.
`SDKCapabilities` preserves unknown bits; nil omits the field while `[]` encodes zero.
These flags are explicit caller input, not inferred by this Swift library.

### Bundle field 91

`APMMeasurement+Event.o` at `0x12e4–0x1300` sends `sbtMicros` through
`NANOSetInt64(bundle, 57, value)` only when the SDK's value is positive.
The encoder at `0x5f4–0x608` reads slot 57 (pointer offset `0x1c8`) and writes
nanopb data offset `0x578`, tag 91. The model accepts all signed int64 wire values
for decoding; it does not invent a clock origin or generate this value automatically.

### Forward compatibility

Unknown fields are skipped in the batch wrapper, user attributes, parameters and nested
item containers as well as bundles and events. Malformed known fields and missing required
model values still throw. A literal wire fixture tests tags 87/91 independently of this
library's encoder, including unknown flag bits and a negative int64 value.

### Remaining limits

Bundle fields 15, 22, 28, 29, 34, 41, 47, 50, 55, 59, 67, 75, 79, 84, 86, 89 and
Event fields 5–7 remain unmodeled. Known names without fully verified behavior are not
sufficient evidence to implement their generators. The convenience event builder in
`Analytics.swift` still contains captured identifiers, counters, config/experiment values
and a synthetic engagement event; use `log(payload:)` with real caller-owned state.
No live upload or Firebase DebugView acceptance has been validated in this follow-up.
