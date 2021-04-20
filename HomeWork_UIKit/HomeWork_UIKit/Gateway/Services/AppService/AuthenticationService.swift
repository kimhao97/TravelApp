import Foundation
import NeoNetworking
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
        let phoneSaved = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as? String
        let passwordSaved = persistentDataService.getItem(fromKey: Notification.Name.password.rawValue) as? String
        
        if phoneSaved == phone && passwordSaved == password {
            output.result = .init(message: nil)
            completionHandler(output, nil)
        } else {
            output.error = .init(data: nil, message: "The email address and phone number that you've entered doesn't match any account.", success: false)
            completionHandler(nil, output.error)
        }
    }
    
    func signUp(profile: Profile) {
        guard let persistentDataService = persistentDataProvider else { return }
        
        persistentDataService.set(item: profile.name, toKey: Notification.Name.userName.rawValue)
        persistentDataService.set(item: profile.email, toKey: Notification.Name.email.rawValue)
        persistentDataService.set(item: profile.phone, toKey: Notification.Name.phone.rawValue)
        persistentDataService.set(item: profile.address, toKey: Notification.Name.address.rawValue)
        persistentDataService.set(item: profile.password, toKey: Notification.Name.password.rawValue)
    }
}
