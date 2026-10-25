import ProtobufKit

/// `appmeasurement.MeasurementBundle`
///
/// Field numbers, wire types and meanings were taken from `GoogleAppMeasurement` 13.0.1
/// (`gmp_measurement.pb.o` field tables and the `APMMeasurement` code that fills each field).
/// See `docs/measurement-protocol.md` for the full table.
public struct Payload: ProtobufMessage, Equatable {
  /// 1: `APMMeasurementProtocolVersion` (always `1`)
  public var protocolVersion: UInt
  /// 2
  public var events: [EventPayload]?
  /// 3: user properties (`_fot`, `_sid`, `_sno`, ...)
  public var userAttributes: [ValueKeyValue]
  /// 4: time when the bundle is uploaded
  public var uploadTimestampMillis: UInt?
  /// 5: timestamp of the oldest event in the bundle
  public var startTimestampMillis: UInt?
  /// 6: timestamp of the newest event in the bundle
  public var endTimestampMillis: UInt?
  /// 7: `endTimestampMillis` of the previous bundle
  public var previousBundleEndTimestampMillis: UInt?
  /// 8: platform (`"ios"`)
  public var os: String
  /// 9
  public var osVersion: String
  /// 10
  public var deviceModel: String
  /// 11: e.g. `"ja-jp"`
  public var userDefaultLanguage: String?
  /// 12: e.g. `540` for UTC+9
  public var timeZoneOffsetMinutes: Int?
  /// 13: `"manual_install"` or App Store
  public var installMethod: String
  /// 14
  public var bundleId: String
  /// 16
  public var appVersion: String
  /// 17: `appMeasurementLibraryVersion` when the event was recorded
  public var gmpVersion: UInt?
  /// 18: `appMeasurementLibraryVersion` when the bundle is uploaded
  public var uploadingGmpVersion: UInt?
  /// 19: advertising identifier (IDFA)
  public var resettableDeviceId: String?
  /// 20
  public var limitedAdTracking: Bool?
  /// 21
  public var appInstanceId: String?
  /// 23: incremented for each bundle (`lastBundleIndex`)
  public var bundleSequentialIndex: UInt?
  /// 24: health monitoring data
  public var healthMonitor: String?
  /// 25
  public var googleAppId: String
  /// 26: `startTimestampMillis` of the previous bundle
  public var previousBundleStartTimestampMillis: UInt?
  /// 27: `UIDevice.identifierForVendor` (IDFV)
  public var vendorDeviceId: String?
  /// 30: Firebase Installation ID
  public var firebaseInstanceId: String?
  /// 31
  public var appVersionMajor: UInt?
  /// 32
  public var appVersionMinor: UInt?
  /// 33
  public var appVersionRelease: UInt?
  /// 35: remote config version
  public var configVersion: UInt?
  /// 39: number of failed upload attempts of this bundle
  public var retryCount: UInt?
  /// 45
  public var experimentIds: [UInt]
  /// 52: `"G1"` + ad_storage + analytics_storage. See ``ConsentSettings/consentSignals``
  public var consentSignals: String?
  /// 53: ATT authorization status (`appleConsentStatus`)
  public var appleConsentStatus: UInt?
  /// 63
  public var sessionStitchingToken: String?
  /// 64: e.g. `["google_signals"]`
  public var redactedFields: [String]
  /// 65
  public var ephemeralAppInstanceId: String?
  /// 71: `"1"` + diagnostic source per consent type. See ``ConsentSettings/consentDiagnostics``
  public var consentDiagnostics: String?
  /// 72: whether the device is in a DMA (Digital Markets Act) region
  public var isDMARegion: Bool?
  /// 73: linked core platform services joined (`"-"` when empty)
  public var corePlatformServices: String?
  /// 77: incremented for each delivery (`lastDeliveryIndex`)
  public var deliveryIndex: UInt?
  /// 87: consent availability and linked conversion libraries.
  public var sdkCapabilities: SDKCapabilities?
  /// 91: SDK's `sbtMicros` value, in microseconds. Its clock origin is unconfirmed.
  public var sbtMicros: Int64?

  public init(
    protocolVersion: UInt = 1,
    events: [EventPayload]? = nil,
    userAttributes: [ValueKeyValue],
    uploadTimestampMillis: UInt? = nil,
    startTimestampMillis: UInt? = nil,
    endTimestampMillis: UInt? = nil,
    previousBundleEndTimestampMillis: UInt? = nil,
    os: String,
    osVersion: String,
    deviceModel: String,
    userDefaultLanguage: String? = nil,
    timeZoneOffsetMinutes: Int? = nil,
    installMethod: String,
    bundleId: String,
    appVersion: String,
    gmpVersion: UInt? = nil,
    uploadingGmpVersion: UInt? = nil,
    resettableDeviceId: String? = nil,
    limitedAdTracking: Bool? = nil,
    appInstanceId: String? = nil,
    bundleSequentialIndex: UInt? = nil,
    healthMonitor: String? = nil,
    googleAppId: String,
    previousBundleStartTimestampMillis: UInt? = nil,
    vendorDeviceId: String? = nil,
    firebaseInstanceId: String? = nil,
    appVersionMajor: UInt? = nil,
    appVersionMinor: UInt? = nil,
    appVersionRelease: UInt? = nil,
    configVersion: UInt? = nil,
    retryCount: UInt? = nil,
    experimentIds: [UInt] = [],
    consentSignals: String? = nil,
    appleConsentStatus: UInt? = nil,
    sessionStitchingToken: String? = nil,
    redactedFields: [String] = [],
    ephemeralAppInstanceId: String? = nil,
    consentDiagnostics: String? = nil,
    isDMARegion: Bool? = nil,
    corePlatformServices: String? = nil,
    deliveryIndex: UInt? = nil,
    sdkCapabilities: SDKCapabilities? = nil,
    sbtMicros: Int64? = nil
  ) {
    self.protocolVersion = protocolVersion
    self.events = events
    self.userAttributes = userAttributes
    self.uploadTimestampMillis = uploadTimestampMillis
    self.startTimestampMillis = startTimestampMillis
    self.endTimestampMillis = endTimestampMillis
    self.previousBundleEndTimestampMillis = previousBundleEndTimestampMillis
    self.os = os
    self.osVersion = osVersion
    self.deviceModel = deviceModel
    self.userDefaultLanguage = userDefaultLanguage
    self.timeZoneOffsetMinutes = timeZoneOffsetMinutes
    self.installMethod = installMethod
    self.bundleId = bundleId
    self.appVersion = appVersion
    self.gmpVersion = gmpVersion
    self.uploadingGmpVersion = uploadingGmpVersion
    self.resettableDeviceId = resettableDeviceId
    self.limitedAdTracking = limitedAdTracking
    self.appInstanceId = appInstanceId
    self.bundleSequentialIndex = bundleSequentialIndex
    self.healthMonitor = healthMonitor
    self.googleAppId = googleAppId
    self.previousBundleStartTimestampMillis = previousBundleStartTimestampMillis
    self.vendorDeviceId = vendorDeviceId
    self.firebaseInstanceId = firebaseInstanceId
    self.appVersionMajor = appVersionMajor
    self.appVersionMinor = appVersionMinor
    self.appVersionRelease = appVersionRelease
    self.configVersion = configVersion
    self.retryCount = retryCount
    self.experimentIds = experimentIds
    self.consentSignals = consentSignals
    self.appleConsentStatus = appleConsentStatus
    self.sessionStitchingToken = sessionStitchingToken
    self.redactedFields = redactedFields
    self.ephemeralAppInstanceId = ephemeralAppInstanceId
    self.consentDiagnostics = consentDiagnostics
    self.isDMARegion = isDMARegion
    self.corePlatformServices = corePlatformServices
    self.deliveryIndex = deliveryIndex
    self.sdkCapabilities = sdkCapabilities
    self.sbtMicros = sbtMicros
  }

  public init(from decoder: inout ProtobufDecoder) throws {
    var protocolVersion: UInt?
    var events: [EventPayload] = []
    var userAttributes: [ValueKeyValue] = []
    var uploadTimestampMillis: UInt?
    var startTimestampMillis: UInt?
    var endTimestampMillis: UInt?
    var previousBundleEndTimestampMillis: UInt?
    var os: String?
    var osVersion: String?
    var deviceModel: String?
    var userDefaultLanguage: String?
    var timeZoneOffsetMinutes: Int?
    var installMethod: String?
    var bundleId: String?
    var appVersion: String?
    var gmpVersion: UInt?
    var uploadingGmpVersion: UInt?
    var resettableDeviceId: String?
    var limitedAdTracking: Bool?
    var appInstanceId: String?
    var bundleSequentialIndex: UInt?
    var healthMonitor: String?
    var googleAppId: String?
    var previousBundleStartTimestampMillis: UInt?
    var vendorDeviceId: String?
    var firebaseInstanceId: String?
    var appVersionMajor: UInt?
    var appVersionMinor: UInt?
    var appVersionRelease: UInt?
    var configVersion: UInt?
    var retryCount: UInt?
    var experimentIds: [UInt] = []
    var consentSignals: String?
    var appleConsentStatus: UInt?
    var sessionStitchingToken: String?
    var redactedFields: [String] = []
    var ephemeralAppInstanceId: String?
    var consentDiagnostics: String?
    var isDMARegion: Bool?
    var corePlatformServices: String?
    var deliveryIndex: UInt?
    var sdkCapabilities: SDKCapabilities?
    var sbtMicros: Int64?

    while let field = try decoder.nextField() {
      switch field.tag {
      case 1: protocolVersion = try decoder.uintField(field)
      case 2:
        let event: EventPayload = try decoder.messageField(field)
        events.append(event)
      case 3:
        let userAttribute: ValueKeyValue = try decoder.messageField(field)
        userAttributes.append(userAttribute)
      case 4: uploadTimestampMillis = try decoder.uintField(field)
      case 5: startTimestampMillis = try decoder.uintField(field)
      case 6: endTimestampMillis = try decoder.uintField(field)
      case 7: previousBundleEndTimestampMillis = try decoder.uintField(field)
      case 8: os = try decoder.stringField(field)
      case 9: osVersion = try decoder.stringField(field)
      case 10: deviceModel = try decoder.stringField(field)
      case 11: userDefaultLanguage = try decoder.stringField(field)
      case 12: timeZoneOffsetMinutes = Int(Int32(truncatingIfNeeded: try decoder.uintField(field)))
      case 13: installMethod = try decoder.stringField(field)
      case 14: bundleId = try decoder.stringField(field)
      case 16: appVersion = try decoder.stringField(field)
      case 17: gmpVersion = try decoder.uintField(field)
      case 18: uploadingGmpVersion = try decoder.uintField(field)
      case 19: resettableDeviceId = try decoder.stringField(field)
      case 20: limitedAdTracking = try decoder.boolField(field)
      case 21: appInstanceId = try decoder.stringField(field)
      case 23: bundleSequentialIndex = try decoder.uintField(field)
      case 24: healthMonitor = try decoder.stringField(field)
      case 25: googleAppId = try decoder.stringField(field)
      case 26: previousBundleStartTimestampMillis = try decoder.uintField(field)
      case 27: vendorDeviceId = try decoder.stringField(field)
      case 30: firebaseInstanceId = try decoder.stringField(field)
      case 31: appVersionMajor = try decoder.uintField(field)
      case 32: appVersionMinor = try decoder.uintField(field)
      case 33: appVersionRelease = try decoder.uintField(field)
      case 35: configVersion = try decoder.uintField(field)
      case 39: retryCount = try decoder.uintField(field)
      case 45: experimentIds.append(try decoder.uintField(field))
      case 52: consentSignals = try decoder.stringField(field)
      case 53: appleConsentStatus = try decoder.uintField(field)
      case 63: sessionStitchingToken = try decoder.stringField(field)
      case 64: redactedFields.append(try decoder.stringField(field))
      case 65: ephemeralAppInstanceId = try decoder.stringField(field)
      case 71: consentDiagnostics = try decoder.stringField(field)
      case 72: isDMARegion = try decoder.boolField(field)
      case 73: corePlatformServices = try decoder.stringField(field)
      case 77: deliveryIndex = try decoder.uintField(field)
      case 87:
        sdkCapabilities = SDKCapabilities(
          rawValue: UInt32(truncatingIfNeeded: try decoder.uintField(field)))
      case 91: sbtMicros = Int64(bitPattern: UInt64(try decoder.uintField(field)))
      // 22, 15, 28, 29, 34, 41, 47, 50, 55, 59, 67, 75, 79, 84, 86, 89 are not modeled yet.
      default: try decoder.skipField(field)
      }
    }

    if let protocolVersion, let os, let osVersion, let deviceModel, let installMethod, let bundleId,
      let appVersion, let googleAppId
    {
      self.init(
        protocolVersion: protocolVersion,
        events: events,
        userAttributes: userAttributes,
        uploadTimestampMillis: uploadTimestampMillis,
        startTimestampMillis: startTimestampMillis,
        endTimestampMillis: endTimestampMillis,
        previousBundleEndTimestampMillis: previousBundleEndTimestampMillis,
        os: os,
        osVersion: osVersion,
        deviceModel: deviceModel,
        userDefaultLanguage: userDefaultLanguage,
        timeZoneOffsetMinutes: timeZoneOffsetMinutes,
        installMethod: installMethod,
        bundleId: bundleId,
        appVersion: appVersion,
        gmpVersion: gmpVersion,
        uploadingGmpVersion: uploadingGmpVersion,
        resettableDeviceId: resettableDeviceId,
        limitedAdTracking: limitedAdTracking,
        appInstanceId: appInstanceId,
        bundleSequentialIndex: bundleSequentialIndex,
        healthMonitor: healthMonitor,
        googleAppId: googleAppId,
        previousBundleStartTimestampMillis: previousBundleStartTimestampMillis,
        vendorDeviceId: vendorDeviceId,
        firebaseInstanceId: firebaseInstanceId,
        appVersionMajor: appVersionMajor,
        appVersionMinor: appVersionMinor,
        appVersionRelease: appVersionRelease,
        configVersion: configVersion,
        retryCount: retryCount,
        experimentIds: experimentIds,
        consentSignals: consentSignals,
        appleConsentStatus: appleConsentStatus,
        sessionStitchingToken: sessionStitchingToken,
        redactedFields: redactedFields,
        ephemeralAppInstanceId: ephemeralAppInstanceId,
        consentDiagnostics: consentDiagnostics,
        isDMARegion: isDMARegion,
        corePlatformServices: corePlatformServices,
        deliveryIndex: deliveryIndex,
        sdkCapabilities: sdkCapabilities,
        sbtMicros: sbtMicros
      )
    } else {
      throw ProtobufDecodingError.missingField
    }
  }

  public func encode(to encoder: inout ProtobufEncoder) throws {
    encoder.uintField(1, protocolVersion, defaultValue: nil)
    for event in events ?? [] {
      try encoder.messageField(2, event)
    }
    for userAttribute in userAttributes {
      try encoder.messageField(3, userAttribute)
    }
    uploadTimestampMillis.map { encoder.uintField(4, $0, defaultValue: nil) }
    startTimestampMillis.map { encoder.uintField(5, $0, defaultValue: nil) }
    endTimestampMillis.map { encoder.uintField(6, $0, defaultValue: nil) }
    previousBundleEndTimestampMillis.map { encoder.uintField(7, $0, defaultValue: nil) }
    try encoder.stringField(8, os, defaultValue: nil)
    try encoder.stringField(9, osVersion, defaultValue: nil)
    try encoder.stringField(10, deviceModel, defaultValue: nil)
    try userDefaultLanguage.map { try encoder.stringField(11, $0, defaultValue: nil) }
    // int32: negative values are encoded as 64-bit two's complement varint (not zigzag)
    timeZoneOffsetMinutes.map { encoder.uintField(12, UInt(bitPattern: $0), defaultValue: nil) }
    try encoder.stringField(13, installMethod, defaultValue: nil)
    try encoder.stringField(14, bundleId, defaultValue: nil)
    try encoder.stringField(16, appVersion, defaultValue: nil)
    gmpVersion.map { encoder.uintField(17, $0, defaultValue: nil) }
    uploadingGmpVersion.map { encoder.uintField(18, $0, defaultValue: nil) }
    try resettableDeviceId.map { try encoder.stringField(19, $0, defaultValue: nil) }
    limitedAdTracking.map { encoder.boolField(20, $0, defaultValue: nil) }
    try appInstanceId.map { try encoder.stringField(21, $0, defaultValue: nil) }
    bundleSequentialIndex.map { encoder.uintField(23, $0, defaultValue: nil) }
    try healthMonitor.map { try encoder.stringField(24, $0, defaultValue: nil) }
    try encoder.stringField(25, googleAppId, defaultValue: nil)
    previousBundleStartTimestampMillis.map { encoder.uintField(26, $0, defaultValue: nil) }
    try vendorDeviceId.map { try encoder.stringField(27, $0, defaultValue: nil) }
    try firebaseInstanceId.map { try encoder.stringField(30, $0, defaultValue: nil) }
    appVersionMajor.map { encoder.uintField(31, $0, defaultValue: nil) }
    appVersionMinor.map { encoder.uintField(32, $0, defaultValue: nil) }
    appVersionRelease.map { encoder.uintField(33, $0, defaultValue: nil) }
    configVersion.map { encoder.uintField(35, $0, defaultValue: nil) }
    retryCount.map { encoder.uintField(39, $0, defaultValue: nil) }
    // repeated, not packed
    for experimentId in experimentIds {
      encoder.uintField(45, experimentId, defaultValue: nil)
    }
    try consentSignals.map { try encoder.stringField(52, $0, defaultValue: nil) }
    appleConsentStatus.map { encoder.uintField(53, $0, defaultValue: nil) }
    try sessionStitchingToken.map { try encoder.stringField(63, $0, defaultValue: nil) }
    for redactedField in redactedFields {
      try encoder.stringField(64, redactedField, defaultValue: nil)
    }
    try ephemeralAppInstanceId.map { try encoder.stringField(65, $0, defaultValue: nil) }
    try consentDiagnostics.map { try encoder.stringField(71, $0, defaultValue: nil) }
    isDMARegion.map { encoder.boolField(72, $0, defaultValue: nil) }
    try corePlatformServices.map { try encoder.stringField(73, $0, defaultValue: nil) }
    deliveryIndex.map { encoder.uintField(77, $0, defaultValue: nil) }
    sdkCapabilities.map { encoder.uintField(87, UInt($0.rawValue), defaultValue: nil) }
    sbtMicros.map { encoder.uintField(91, UInt(truncatingIfNeeded: $0), defaultValue: nil) }
  }
}
