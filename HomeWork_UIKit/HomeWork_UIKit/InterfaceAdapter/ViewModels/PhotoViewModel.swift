import Foundation
import RxSwift
import RxCocoa

final class PhotoViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    var favorites = [Favorite]()
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
//                    self.photos.accept(data ?? [Photo]())
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension PhotoViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
//        let isFavoriteLoading: Driver<Bool>
//        let isSocialLoading: Driver<Bool>
    }
}
