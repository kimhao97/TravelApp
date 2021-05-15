import Foundation
import RxSwift
import RxCocoa

typealias ProfileInfor = (userName: String, website: String, address: String, avatar: UIImage?)

final class EditProfileViewModel: BaseViewModel, ViewModelTransformable {
    
    let authenUsecase: AuthenUseCaseable = AuthenUsecaseImplement()
    var profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    func transform(input: Input) -> Output {
        return Output(isSaved: saveProfile(input: input).asDriverOnErrorJustComplete())
    }
    
    func saveProfile(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input.saveTrigger
            .withLatestFrom(input.profileInfor)
            .drive(onNext: { [weak self] infor in
                guard let self = self else { return }
                self.profile.setUsername(with: infor.userName)
                self.profile.setAddress(with: infor.address)
                self.profile.setWebsite(with: infor.website)
                self.profile.setAvatar(image: infor.avatar)
                self.authenUsecase.saveProfile(profile: self.profile) { done in
                    if done {
                        publishSubject.onNext(true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return publishSubject
    }
}

extension EditProfileViewModel {
    struct Input {
        let saveTrigger: Driver<Void>
        let profileInfor: Driver<ProfileInfor>
    }
    
    struct Output {
        let isSaved: Driver<Bool>
    }
}
