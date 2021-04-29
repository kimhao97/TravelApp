import Foundation
import NeoNetworking
import Firebase

protocol ProfilesServiceable {
    func login(phone: String,
               password: String,
               completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                            _ error: AppError?) -> Void)
    func signUp(profile: Profile)
}

class ProfilesServiceImplement: ProfilesServiceable {
    
    var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    
    func login(phone: String,
              password: String,
              completionHandler: @escaping (_ user: AuthenticateLoginOutput?,
                                           _ error: AppError?) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return }
       
        let output = AuthenticateLoginOutput()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: phone, password: password) { result, error in
            if let error = error {
                output.error = .init(data: nil, message: error.localizedDescription, success: false)
                completionHandler(nil, output.error)
                return
            } else {
                output.result = .init(message: nil)
                completionHandler(output, nil)
            }
        }
//        let phoneSaved = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as? String
//        let passwordSaved = persistentDataService.getItem(fromKey: Notification.Name.password.rawValue) as? String
//
//        if phoneSaved == phone && passwordSaved == password {
//            output.result = .init(message: nil)
//            completionHandler(output, nil)
//        } else {
//            output.error = .init(data: nil, message: "The email address and phone number that you've entered doesn't match any account.", success: false)
//            completionHandler(nil, output.error)
//        }
    }
    
    func signUp(profile: Profile) {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: profile.email, password: profile.password) {
            result, error in
            if let error = error {
                print("Sign Up message: \(error.localizedDescription)")
            }
        }
        
        UserEndPoint.postUser.post(data: profile, createNewKey: true) { result in
            switch result {
            case .failure(let error):
                print("Save FirebaseDatabase is failed: \(error.localizedDescription)")
            case .success(_):
                break
            }
        }
//        guard let persistentDataService = persistentDataProvider else { return }
//
//        persistentDataService.set(item: profile.name, toKey: Notification.Name.userName.rawValue)
//        persistentDataService.set(item: profile.email, toKey: Notification.Name.email.rawValue)
//        persistentDataService.set(item: profile.phone, toKey: Notification.Name.phone.rawValue)
//        persistentDataService.set(item: profile.address, toKey: Notification.Name.address.rawValue)
//        persistentDataService.set(item: profile.password, toKey: Notification.Name.password.rawValue)
    }
}
