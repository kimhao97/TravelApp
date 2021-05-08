import Foundation
import RxCocoa
import RxSwift

protocol AuthenUseCaseable: class {
    func login(phone: String, password: String) -> Observable<Result<Profile?, AppError>>
    func signUp(profile: Profile) -> Observable<Result<Profile?, AppError>>
}

class AuthenUsecaseImplement: AuthenUseCaseable {
    
    let profileService: ProfilesServiceable
    
    init(service: ProfilesServiceable = ProfilesServiceImplement()) {
        profileService = service
    }
    
    func login(phone: String, password: String) -> Observable<Result<Profile?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.profileService.login(phone: phone, password: password) { data, error in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(nil))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func signUp(profile: Profile) -> Observable<Result<Profile?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.profileService.signUp(profile: profile) { data, error in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(nil))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
}
