import NeoNetworking

class AuthenticateLoginOutput: NeoApiOutputable {
    var result: ResultLogin?
    var error: AppError?
    var systemError: Error?
    var responseParser: Parseable = CodeableParser<ResultType>()
    var errorParser: Parseable = CodeableParser<ErrorType>()
}
// MARK: - ResultLogin
struct ResultLogin: Codable {
    let message: String?
    let data: User?
    let statusCode: Int?
    enum CodingKeys: String, CodingKey {
        case message, data
        case statusCode = "status_code"
    }
}

struct AppError: Codable, Error {
  var data: Data?
  var message: String = ""
  var success: Bool = false
}
