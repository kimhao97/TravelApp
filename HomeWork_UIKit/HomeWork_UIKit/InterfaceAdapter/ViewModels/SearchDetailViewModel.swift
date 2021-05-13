import Foundation
import RxSwift
import RxCocoa

final class SearchDetailViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .query
            .distinctUntilChanged()
            .debounce(.milliseconds(500))
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] text -> Driver<Result<[Photo]?, AppError>> in
                let query = text.replacingOccurrences(of: " ", with: "+")
                return self.photoUsecase.loadAPI(with: query.trimmingCharacters(in: .whitespaces), queryType: .search).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if let data = data {
                        self.photos = data
                    }
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.photos = [Photo]()
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
}

extension SearchDetailViewModel {
    struct Input {
        let query: Driver<String>
    }

    struct Output {
        let isLoading: Driver<Bool>
    }
}
