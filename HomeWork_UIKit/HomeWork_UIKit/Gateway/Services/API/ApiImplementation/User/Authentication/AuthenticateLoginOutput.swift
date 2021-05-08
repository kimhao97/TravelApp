import NeoNetworking

class AuthenticateLoginOutput {
    var result: ResultLogin?
    var error: AppError?
    var systemError: Error?
}
// MARK: - ResultLogin

struct ResultLogin {
    let message: String?
}

//struct AppError: Codable, Error {
//  var data: Data?
//  var message: String = ""
//  var success: Bool = false
//}
