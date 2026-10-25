import Foundation

public struct Session: Sendable {
  /// `first_open_after_install`
  ///
  /// 1の場合、インストール後の最初の`first_open`であることを示す
  var firstOpenAfterInstall: Bool  // _fi
  /// `first_open_time`
  ///
  /// ユーザーがアプリを最初に開いた時間(UNIXタイムスタンプ、ミリ秒)を示しています。
  var firstOpenTime: TimeInterval  // _fot
  /// 0の場合、広告がパーソナライズされていることを示します
  var nonPersonalizedAds: Bool  // _npa
  /// `ga_session_id`
  ///
  /// セッション開始時のUNIXタイムスタンプ(秒)
  var sessionId: UInt  // _sid
  /// `ga_session_number`
  ///
  /// セッションの回数を示します。そのユーザーにとって何回目のセッションかを示します
  var sessionNumber: UInt  // _sno
  /// `lifetime_user_engagement`
  ///
  /// ユーザーがこれまでにアプリで費やした総時間を示します（単位はミリ秒）
  var lifetimeEngagement: TimeInterval  // _lte
  /// `session_user_engagement`
  ///
  /// 現在のセッションでユーザーが費やしたエンゲージメント時間を示します（単位はミリ秒）
  var sessionEngagement: TimeInterval  // _se

  /// User ID
  ///
  /// This feature must be used in accordance with [Google's Privacy Policy](https://www.google.com/policies/privacy)
  /// The user ID to ascribe to the user of this app on this device, which must be non-empty and no more than 256 characters long.
  var userId: String?  // _id

  var parameters: [ValueKeyValue] {
    let setTimestampMillis = UInt(Date.now.timeIntervalSince1970 * 1000)

    var params: [ValueKeyValue] = [
      .init(
        date: setTimestampMillis,
        key: "_fi",
        value: .uint(firstOpenAfterInstall ? 1 : 0)
      ),
      .init(
        date: setTimestampMillis,
        key: "_fot",
        value: .uint(UInt(firstOpenTime))
      ),
      .init(
        date: setTimestampMillis,
        key: "_npa",
        value: .uint(nonPersonalizedAds ? 1 : 0)
      ),
      .init(
        date: setTimestampMillis,
        key: "_sid",
        value: .uint(sessionId)
      ),
      .init(
        date: setTimestampMillis,
        key: "_sno",
        value: .uint(sessionNumber)
      ),
      .init(
        date: setTimestampMillis,
        key: "_lte",
        value: .uint(UInt(lifetimeEngagement))
      ),
      .init(
        date: setTimestampMillis,
        key: "_se",
        value: .uint(UInt(sessionEngagement))
      ),
    ]

    if let userId {
      params.append(
        .init(
          date: setTimestampMillis,
          key: "_id",
          value: .string(userId)
        ))
    }

    return params
  }
}
