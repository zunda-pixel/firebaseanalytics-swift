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
    let payload = Payload(
      value: 1,
      events: [
        EventPayload(
          eventName: eventName,
          parameters: parameters.merging([.platform: "app"]) { $1 }.compactMapValues { $0 },
          previousTimestampMillis: UInt(Date.now.timeIntervalSince1970 * 100),
          timestampMillis: UInt(Date.now.timeIntervalSince1970 * 100)
        ),
        EventPayload(
          eventName: "_e",
          parameters: ["_et": .uint(891), .platform: "auto"],
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
      value21: "BC75E8783E8141ECB7A179248F24080C",  // fix // app_instance_id
      value23: 25,  // count up // bundle_sequential_index
      googleAppId: clientInformation.googleAppId,
      value26: UInt(Date.now.timeIntervalSince1970 * 100),  // free // previous_bundle_start_timestamp_millis
      value27: "C86A6B98-E407-4954-BC16-F693A22F9FA9",  // fix // resettable_device_id
      value30: "d4Xw8qsiRUIBoMYlsYHnot",  // fix // firebase_instance_id
      value31: 1, // app_version_major
      value35: 1_727_127_969_769_945,  // fix // config_version
      value45: 42_820_019,  // fix
      value52: "G1--",  // fix // consent_signals
      value64: "google_signals",  // fix
      value71: "19911",  // fix // consent_diagnostics
      value72: 0,  // fix
      value77: 13  // count up
    )

    try await log(payload: payload)
  }
}

extension Analytics: Sendable where HTTPClient: Sendable {}
