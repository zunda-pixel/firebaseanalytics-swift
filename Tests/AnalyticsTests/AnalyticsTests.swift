import Foundation
import ProtobufKit
import Testing

@testable import Analytics

struct PayloadTests {
  let payload = Payload(
    events: [
      EventPayload(
        eventName: "login",
        parameters: [.method: "Google", "count": .uint(3), "price": .float(1.5)],
        previousTimestampMillis: 1_737_555_000_000,
        timestampMillis: 1_737_555_666_000
      )
    ],
    userAttributes: [.init(date: 1_737_555_666_000, key: "_sid", value: .uint(1_737_555_666))],
    uploadTimestampMillis: 1_737_555_667_000,
    startTimestampMillis: 1_737_555_666_000,
    endTimestampMillis: 1_737_555_666_000,
    previousBundleEndTimestampMillis: 1_737_555_000_000,
    os: "ios",
    osVersion: "18.3",
    deviceModel: "iPhone17,3",
    userDefaultLanguage: "ja-jp",
    timeZoneOffsetMinutes: -300,
    installMethod: "manual_install",
    bundleId: "com.apple.SampleApp",
    appVersion: "1.0",
    gmpVersion: 110700,
    uploadingGmpVersion: 110700,
    limitedAdTracking: true,
    appInstanceId: "BC75E8783E8141ECB7A179248F24080C",
    bundleSequentialIndex: 25,
    googleAppId: "1:21332412389:ios:11681asd2a3cd5d8",
    previousBundleStartTimestampMillis: 1_737_555_000_000,
    vendorDeviceId: "C86A6B98-E407-4954-BC16-F693A22F9FA9",
    firebaseInstanceId: "d4Xw8qsiRUIBoMYlsYHnot",
    appVersionMajor: 1,
    configVersion: 1_727_127_969_769_945,
    retryCount: 2,
    experimentIds: [42_820_019, 1],
    consentSignals: "G1--",
    redactedFields: ["google_signals"],
    consentDiagnostics: "19911",
    isDMARegion: false,
    deliveryIndex: 13
  )

  @Test
  func roundTrip() throws {
    let data = try ProtobufEncoder.encoding(payload)
    var decoder = ProtobufDecoder(data)
    let decoded = try Payload(from: &decoder)
    #expect(decoded == payload)
  }

  @Test
  func repeatedFieldsAreNotPacked() throws {
    let data = try ProtobufEncoder.encoding(payload)
    var decoder = ProtobufDecoder(data)
    var experimentIdTags = 0
    while let field = try decoder.nextField() {
      if field.tag == 45 {
        #expect(field.wireType == .varint)
        experimentIdTags += 1
      }
      try decoder.skipField(field)
    }
    #expect(experimentIdTags == 2)
  }

  @Test
  func negativeTimeZoneOffsetIsInt32Varint() throws {
    let data = try ProtobufEncoder.encoding(payload)
    var decoder = ProtobufDecoder(data)
    while let field = try decoder.nextField() {
      if field.tag == 12 {
        #expect(Int(bitPattern: try decoder.uintField(field)) == -300)
        return
      }
      try decoder.skipField(field)
    }
    Issue.record("field 12 not found")
  }

  @Test
  func unknownFieldsAreSkipped() throws {
    var data = try ProtobufEncoder.encoding(payload)
    // 91: varint, 89: length-delimited
    data += try ProtobufEncoder.encoding { encoder in
      encoder.uintField(91, 123, defaultValue: nil)
      try encoder.stringField(89, "unknown", defaultValue: nil)
    }
    var decoder = ProtobufDecoder(data)
    #expect(try Payload(from: &decoder) == payload)
  }
}

struct ParameterTests {
  @Test
  func valueUsesEventParamFieldNumbers() throws {
    let data = try ProtobufEncoder.encoding(Parameter.Value.string("a"))
    var decoder = ProtobufDecoder(data)
    #expect(try decoder.nextField()?.tag == 2)

    let intData = try ProtobufEncoder.encoding(Parameter.Value.uint(1))
    var intDecoder = ProtobufDecoder(intData)
    #expect(try intDecoder.nextField()?.tag == 3)
  }

  @Test
  func itemsRoundTrip() throws {
    let event = EventPayload(
      eventName: "purchase",
      parameters: [
        "items": .array([
          .dictionary(["item_name": "Item1", "quantity": .uint(1)]),
          .dictionary(["item_name": "Item2", "price": .float(0.5)]),
        ])
      ],
      previousTimestampMillis: nil,
      timestampMillis: 1_737_555_666_000
    )
    let data = try ProtobufEncoder.encoding(event)
    var decoder = ProtobufDecoder(data)
    #expect(try EventPayload(from: &decoder) == event)
  }
}

struct ConsentSettingsTests {
  @Test
  func consentSignals() {
    #expect(ConsentSettings().consentSignals == "G1--")
    let settings = ConsentSettings(adStorage: .granted, analyticsStorage: .denied)
    #expect(settings.consentSignals == "G110")
  }

  @Test
  func consentDiagnostics() {
    let settings = ConsentSettings(adUserData: .granted, adPersonalization: .granted)
    #expect(
      settings.consentDiagnostics(
        adStorageSource: .init(rawValue: 1),
        adUserDataSource: .init(rawValue: 1),
        adPersonalizationSource: .init(rawValue: 1)
      ) == "19911"
    )
  }
}
