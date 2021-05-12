import Foundation
import RxSwift
import RxCocoa

typealias SignUpInfor = (Profile)

final class SignUpViewModel: BaseViewModel, ViewModelTransformable {
    
    let authenUsecase: AuthenUseCaseable = AuthenUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isRegisted: signUp(input: input).asDriverOnErrorJustComplete())
    }
    
    private func signUp(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        
        input.signUpTrigger
            .withLatestFrom(input.signUpInfor)
            .drive(onNext: { [weak self] infor in
                if infor.name.isEmpty || infor.email.isEmpty || infor.phone.isEmpty || infor.password.isEmpty {
                    publishSubject.onNext(false)
                } else {
                    self?.authenUsecase.signUp(profile: infor)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension SignUpViewModel {
    struct Input {
//        let userName: Driver<String>
//        let email: Driver<String>
//        let phone: Driver<String>
//        let address: Driver<String>
//        let password: Driver<String>
//        let confirmPassword: Driver<String>
        let signUpInfor: Driver<SignUpInfor>
        let signUpTrigger: Driver<Void>
    }
    
    struct Output {
        let isRegisted: Driver<Bool>
    }
}
