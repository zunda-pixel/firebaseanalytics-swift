import Foundation
import HTTPClient
import HTTPTypes
import ProtobufKit

public struct Analytics<HTTPClient: HTTPClientProtocol> {
  public var httpClient: HTTPClient
  public var userAgent: String
  public var endpoint = URL(string: "https://app-analytics-services.com/a")!
  public var clientInformation: ClientInformation
  public var session: Session

  public init(
    httpClient: HTTPClient,
    userAgent: String,
    clientInformation: ClientInformation,
    session: Session
  ) {
    self.httpClient = httpClient
    self.userAgent = userAgent
    self.clientInformation = clientInformation
    self.session = session
  }

  public func log(payload: Payload) async throws {
    let payloadData = try ProtobufEncoder.encoding(NestedValue(value: payload))
    try await log(bodyData: payloadData)
  }

  func log(bodyData: Data) async throws {
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/x-www-form-urlencoded",
        .init("Host")!: "app-analytics-services.com",
        .connection: "keep-alive",
        .accept: "*/*",
        .init("Upload-Draft-Interop-Version")!: "6",
        .init("Upload-Complete")!: "?1",
        .contentEncoding: "gzip",
        .acceptLanguage: "ja",
        .contentLength: "\(bodyData.count)",
        .acceptEncoding: "gzip, deflate, br",
        .userAgent: userAgent,
      ]
    )
    let (data, response) = try await httpClient.execute(for: request, from: bodyData)

    guard response.status.code == 204 else {
      throw RequestError(request: request, body: bodyData, response: (data, response))
    }
  }

  func log(
    eventName: Event.Name,
    parameters: [Parameter.Key: Parameter.Value?]
  ) async throws {
    let nowMillis = UInt(Date.now.timeIntervalSince1970 * 1000)
    let payload = Payload(
      events: [
        EventPayload(
          eventName: eventName,
          parameters: parameters.merging([.platform: "app"]) { $1 }.compactMapValues { $0 },
          previousTimestampMillis: nowMillis,
          timestampMillis: nowMillis
        ),
        EventPayload(
          eventName: "_e",
          parameters: ["_et": .uint(891), .platform: "auto"],
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
      appInstanceId: "BC75E8783E8141ECB7A179248F24080C",  // fix
      bundleSequentialIndex: 25,  // count up
      googleAppId: clientInformation.googleAppId,
      previousBundleStartTimestampMillis: nowMillis,
      vendorDeviceId: "C86A6B98-E407-4954-BC16-F693A22F9FA9",  // fix // IDFV
      firebaseInstanceId: "d4Xw8qsiRUIBoMYlsYHnot",  // fix
      appVersionMajor: 1,
      configVersion: 1_727_127_969_769_945,  // fix
      experimentIds: [42_820_019],  // fix
      consentSignals: ConsentSettings().consentSignals,
      redactedFields: ["google_signals"],  // fix
      consentDiagnostics: "19911",  // fix
      isDMARegion: false,
      deliveryIndex: 13  // count up
    )

    try await log(payload: payload)
  }
}

extension Analytics: Sendable where HTTPClient: Sendable {}
