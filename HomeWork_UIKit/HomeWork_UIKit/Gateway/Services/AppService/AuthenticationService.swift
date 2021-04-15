import Foundation
import NeoNetworking
protocol ProfilesServiceable {
    func login(phone: String,
               password: String,
               completionHandler: @escaping (_ user: AuthenticateLoginOutput?, _ error: AppError?) -> Void)
}

class ProfilesServiceImplement: ProfilesServiceable {
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    /// Check user e-mail has is linked to an actual account
    ///
    /// - Parameters:
    ///   - phone: username
    ///   - completionHandler: completion handler closure
    func login(phone: String,
               password: String,
               completionHandler: @escaping (_ user: AuthenticateLoginOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        let request = AuthenticateLoginAPI(with: AuthenticateLoginInput(username: phone,
                                                                        deviceToken: "123",
                                                                        password: password),
                                           and: AuthenticateLoginOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
}
