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
    // 92: varint, 89: length-delimited
    data += try ProtobufEncoder.encoding { encoder in
      encoder.uintField(92, 123, defaultValue: nil)
      try encoder.stringField(89, "unknown", defaultValue: nil)
    }
    var decoder = ProtobufDecoder(data)
    #expect(try Payload(from: &decoder) == payload)
  }
  @Test
  func sdkMetadataWireFixture() throws {
    // Independent protobuf fixture: field 87 = 0x10f (including an unknown bit),
    // field 91 = -1 as a signed int64 varint, not zigzag.
    let fixture: [UInt8] = [
      0xb8, 0x05, 0x8f, 0x02,
      0xd8, 0x05, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01,
    ]
    let original = try ProtobufEncoder.encoding(payload)
    var decoder = ProtobufDecoder(original + Data(fixture))
    var expected = payload
    expected.sdkCapabilities = [
      .appDataConsentStatus, .privateSetMembership,
      .alphaAppAdsOnDeviceConversion, .googleAdsOnDeviceConversion,
      SDKCapabilities(rawValue: 1 << 8),
    ]
    expected.sbtMicros = -1
    #expect(try Payload(from: &decoder) == expected)
    #expect(Array(try ProtobufEncoder.encoding(expected).suffix(fixture.count)) == fixture)
  }

  @Test
  func sdkMetadataPresence() throws {
    for value: SDKCapabilities? in [nil, []] {
      var expected = payload
      expected.sdkCapabilities = value
      expected.sbtMicros = value == nil ? nil : 0
      let data = try ProtobufEncoder.encoding(expected)
      var decoder = ProtobufDecoder(data)
      #expect(try Payload(from: &decoder) == expected)
    }
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
  @Test
  func diagnosticSourceConversion() {
    let fixtures = [
      (5, 7), (10, 5), (20, 3), (30, 5), (40, 4),
      (0, 0), (-1, 0), (6, 0), (19, 0), (41, 0), (Int.min, 0), (Int.max, 0),
    ]
    for (source, digit) in fixtures {
      #expect(ConsentSettings.DiagnosticSource(consentSource: source).rawValue == digit)
    }
    let settings = ConsentSettings(
      adStorage: .denied, analyticsStorage: .granted,
      adUserData: .denied, adPersonalization: .granted)
    #expect(
      settings.consentDiagnostics(
        adStorageSource: .defaultSetting,
        analyticsStorageSource: .init(consentSource: 20), adUserDataSource: .regional,
        adPersonalizationSource: .delegated) == "11382")
  }

}

struct ForwardCompatibilityTests {
  @Test
  func nestedUnknownFields() throws {
    // Field 100 (varint) before and after known fields at each message level.
    let unknown = Data([0xa0, 0x06, 0x01])
    let valueData = unknown + Data([0x10, 0x01]) + unknown
    var valueDecoder = ProtobufDecoder(valueData)
    // 0x10 is field 2 with the wrong wire type; malformed known fields must fail.
    #expect(throws: (any Error).self) { try Parameter.Value(from: &valueDecoder) }

    var scalarDecoder = ProtobufDecoder(unknown + Data([0x18, 0x2a]) + unknown)
    #expect(try Parameter.Value(from: &scalarDecoder) == .uint(42))

    let keyValue = KeyValue(key: "quantity", value: .uint(42))
    let paramData = unknown + (try ProtobufEncoder.encoding(keyValue)) + unknown
    var paramDecoder = ProtobufDecoder(paramData)
    let decoded = try KeyValue(from: &paramDecoder)
    #expect(decoded.key == keyValue.key)
    #expect(decoded.value == keyValue.value)

    let attribute = ValueKeyValue(date: 0, key: "_sid", value: .uint(42))
    var attributeDecoder = ProtobufDecoder(
      unknown + (try ProtobufEncoder.encoding(attribute)) + unknown)
    #expect(try ValueKeyValue(from: &attributeDecoder) == attribute)

    let array = Array6(value: .dictionary(["quantity": .uint(42)]))
    var arrayDecoder = ProtobufDecoder(unknown + (try ProtobufEncoder.encoding(array)) + unknown)
    #expect(try Array6(from: &arrayDecoder).value == array.value)

    let event = EventPayload(
      eventName: "purchase", parameters: [:],
      previousTimestampMillis: nil, timestampMillis: 0)
    let batch = NestedValue(value: event)
    var batchDecoder = ProtobufDecoder(unknown + (try ProtobufEncoder.encoding(batch)) + unknown)
    #expect(try NestedValue<EventPayload>(from: &batchDecoder) == batch)
  }
}
