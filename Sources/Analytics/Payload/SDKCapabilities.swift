/// MeasurementBundle field 87 in GoogleAppMeasurement 13.0.1.
///
/// Derived from `APMMeasurement+Event.o`: the SDK ORs these four predicates.
/// Unknown bits are preserved when decoding a newer SDK's bundle.
public struct SDKCapabilities: OptionSet, Sendable, Equatable {
  public let rawValue: UInt32

  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }

  /// `hasAppDataConsentStatus` (a status exists, regardless of its value).
  public static let appDataConsentStatus = Self(rawValue: 1 << 0)
  /// `isAPMPrivateSetMembershipClientLinked`.
  public static let privateSetMembership = Self(rawValue: 1 << 1)
  /// `isAlphaAppAdsOnDeviceConversionLinked`.
  public static let alphaAppAdsOnDeviceConversion = Self(rawValue: 1 << 2)
  /// `isGoogleAdsOnDeviceConversionLinked`.
  public static let googleAdsOnDeviceConversion = Self(rawValue: 1 << 3)
}
