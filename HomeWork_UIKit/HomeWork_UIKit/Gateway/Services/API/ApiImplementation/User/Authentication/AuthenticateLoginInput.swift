import NeoNetworking

class AuthenticateLoginInput: NeoApiInputable {
    var requestType: NeoRequestType = .post
    var pathToApi: String = "membership/authenticate"
    var username: String
    var password: String
    var deviceToken: String
    init(username: String, deviceToken: String, password: String) {
        self.username = username
        self.deviceToken = deviceToken
        self.password = password
    }
    func makeRequestableBody() -> [String: Any] {
        return ["phone_or_email": username,
                "password": password,
                "device_token": deviceToken,
                "device_type": "ios"]
    }
    func makeRequestableHeader() -> [String: String] {
        return [:]
//        return ["Content-Type": "application/json"]
    }
}
