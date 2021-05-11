import Foundation
import NeoNetworking
import Firebase

protocol ProfilesServiceable {
    func login(email: String,
               password: String,
               completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                            _ error: AppError?) -> Void)
    func signUp(profile: Profile, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                                                _ error: AppError?) -> Void)
    func saveProfile(profile: Profile)
    func loadProfile(completionHandler: @escaping (Result<Profile?, AppError>) -> Void )
}

class ProfilesServiceImplement: ProfilesServiceable {
    
    var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    func login(email: String, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                           _ error: AppError?) -> Void) {
       
        let output = AuthenticateLoginOutput()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                output.error = .init(data: nil, message: error.localizedDescription, success: false)
                completionHandler(nil, output.error)
                return
            } else {
                output.result = .init(message: nil)
                completionHandler(output, nil)
            }
        }
    }
    
    func signUp(profile: Profile, password: String, completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                                                _ error: AppError?) -> Void) {
        let output = AuthenticateLoginOutput()
        
        FirebaseAuth.Auth.auth().createUser(withEmail: profile.email, password: password) { [weak self]
            result, error in
            if let error = error {
                output.error = .init(data: nil, message: error.localizedDescription, success: false)
                completionHandler(nil, output.error)
            } else {
//                UserEndPoint.postUser.post(data: profile, createNewKey: true) { result in
//                    switch result {
//                    case .failure(let error):
//                        output.error = .init(data: nil, message: error.localizedDescription, success: false)
//                        completionHandler(nil, output.error)
//                    case .success(_):
//                        output.result = .init(message: nil)
//                        completionHandler(output, nil)
//                    }
//                }
                self?.saveProfile(profile: profile)
                output.result = .init(message: nil)
                completionHandler(output, nil)
            }
        }
    }
    
    func saveProfile(profile: Profile) {
        guard let persistentDataService = persistentDataProvider else { return }
        persistentDataService.set(item: profile.id, toKey: Notification.Name.id.rawValue)
        persistentDataService.set(item: profile.name, toKey: Notification.Name.name.rawValue)
        persistentDataService.set(item: profile.userName, toKey: Notification.Name.userName.rawValue)
        persistentDataService.set(item: profile.email, toKey: Notification.Name.email.rawValue)
        persistentDataService.set(item: profile.address, toKey: Notification.Name.address.rawValue)
        persistentDataService.set(item: profile.website, toKey: Notification.Name.website.rawValue)
    }
    
    func loadProfile(completionHandler: @escaping (Result<Profile?, AppError>) -> Void ) {
        guard let persistentDataService = persistentDataProvider else {
            completionHandler(.failure(.init(data: nil, message: "Failed to load data", success: false)))
            return
        }
        let id = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        let name = persistentDataService.getItem(fromKey: Notification.Name.name.rawValue) as! String
        let userName = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
        let email = persistentDataService.getItem(fromKey: Notification.Name.email.rawValue) as! String
        let website = persistentDataService.getItem(fromKey: Notification.Name.website.rawValue) as! String
        let address = persistentDataService.getItem(fromKey: Notification.Name.address.rawValue) as! String
        
        let profile = Profile(id: id, name: name, userName: userName, email: email, website: website, address: address)
        completionHandler( .success(profile))
    }
}
