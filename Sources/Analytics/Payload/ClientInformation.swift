public struct ClientInformation: Sendable {
  public var os: String
  public var osVersion: String
  public var deviceModel: String
  /// e.g. `"ja-jp"`
  public var locale: String
  /// e.g. `540` for UTC+9
  public var timeZoneOffsetMinutes: Int
  public var installMethod: String
  public var bundleId: String
  public var appVersion: String
  public var googleAppId: String
}
