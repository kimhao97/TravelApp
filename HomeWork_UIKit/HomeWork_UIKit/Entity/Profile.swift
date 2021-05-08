import Foundation

struct Profile: Codable {
    var id: String
    var name: String
    var email: String
    var password: String
    var isValidPassword: Bool
}
