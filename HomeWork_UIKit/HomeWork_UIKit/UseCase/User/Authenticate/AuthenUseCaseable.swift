import Foundation
import RxCocoa
import RxSwift

protocol AuthenUseCaseable: class {
    func login(email: String, password: String) -> Observable<Result<Profile?, AppError>>
    func signUp(profile: Profile, password: String) -> Observable<Result<Profile?, AppError>>
    func saveProfile(profile: Profile)
    func loadProfile() -> Observable<Result<Profile?, AppError>>
}

class AuthenUsecaseImplement: AuthenUseCaseable {
    
    let profileService: ProfilesServiceable
    
    init(service: ProfilesServiceable = ProfilesServiceImplement()) {
        profileService = service
    }
    
    func login(email: String, password: String) -> Observable<Result<Profile?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.profileService.login(email: email, password: password) { data, error in
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
    
    func signUp(profile: Profile, password: String) -> Observable<Result<Profile?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.profileService.signUp(profile: profile, password: password) { data, error in
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
    
    func loadProfile() -> Observable<Result<Profile?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.profileService.loadProfile { result in
                switch result {
                case .failure(let error):
                    signal.onNext(.failure(error))
                case .success(let data):
                    signal.onNext(.success(data))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func saveProfile(profile: Profile) {
        profileService.saveProfile(profile: profile)
    }
}
