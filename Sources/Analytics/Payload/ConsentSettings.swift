/// Consent Mode settings
///
/// Mirrors `APMConsentSettingsUtil` in `GoogleAppMeasurement`.
public struct ConsentSettings: Sendable, Equatable {
  public enum Status: Sendable, Equatable {
    case granted
    case denied
  }

  /// Where each consent value came from. Encoded as one digit in ``consentDiagnostics``.
  public struct DiagnosticSource: Sendable, Equatable, RawRepresentable {
    public var rawValue: Int

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

    /// Maps the SDK's consent source priority to its wire diagnostic digit.
    /// The semantic names of priorities 5/10/20/30/40 are not established.
    public init(consentSource: Int) {
      switch consentSource {
      case 5: self = Self(rawValue: 7)
      case 10, 30: self = Self(rawValue: 5)
      case 20: self = Self(rawValue: 3)
      case 40: self = Self(rawValue: 4)
      default: self = .unknown
      }
    }

    /// Default consent setting (except a regional setting).
    public static let defaultSetting = Self(rawValue: 1)
    /// Delegated ad_personalization setting.
    public static let delegated = Self(rawValue: 2)
    /// Regional consent applied by `APMShouldApplyRegionalConsent`.
    public static let regional = Self(rawValue: 8)

    /// Initial value (`resetDiagnosticSources`)
    public static let unknown = Self(rawValue: 0)
    /// Consent type has no value
    public static let notSet = Self(rawValue: 9)
  }

  public var adStorage: Status?
  public var analyticsStorage: Status?
  public var adUserData: Status?
  public var adPersonalization: Status?

  public init(
    adStorage: Status? = nil,
    analyticsStorage: Status? = nil,
    adUserData: Status? = nil,
    adPersonalization: Status? = nil
  ) {
    self.adStorage = adStorage
    self.analyticsStorage = analyticsStorage
    self.adUserData = adUserData
    self.adPersonalization = adPersonalization
  }

  /// `+[APMConsentSettingsUtil consentSignals]`
  ///
  /// `"G1"` followed by `ad_storage` and `analytics_storage`
  /// (`"1"`: granted, `"0"`: denied, `"-"`: not set). e.g. `"G1--"`, `"G111"`
  public var consentSignals: String {
    "G1\(Self.bit(adStorage))\(Self.bit(analyticsStorage))"
  }

  /// `+[APMConsentSettingsUtil consentDiagnostics]`
  ///
  /// `"1"` followed by one ``DiagnosticSource`` digit for
  /// `ad_storage`, `analytics_storage`, `ad_user_data` and `ad_personalization`.
  /// A consent type without value is always ``DiagnosticSource/notSet`` (`9`). e.g. `"19911"`
  public func consentDiagnostics(
    adStorageSource: DiagnosticSource = .unknown,
    analyticsStorageSource: DiagnosticSource = .unknown,
    adUserDataSource: DiagnosticSource = .unknown,
    adPersonalizationSource: DiagnosticSource = .unknown
  ) -> String {
    let sources: [(Status?, DiagnosticSource)] = [
      (adStorage, adStorageSource),
      (analyticsStorage, analyticsStorageSource),
      (adUserData, adUserDataSource),
      (adPersonalization, adPersonalizationSource),
    ]
    return sources.reduce("1") { result, item in
      result + String((item.0 == nil ? DiagnosticSource.notSet : item.1).rawValue)
    }
  }

  /// `APMConsentBitV1`
  static func bit(_ status: Status?) -> String {
    switch status {
    case .granted: "1"
    case .denied: "0"
    case nil: "-"
    }
  }
}
