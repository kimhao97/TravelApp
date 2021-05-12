import Foundation
import RxSwift
import RxCocoa

final class CityDetailViewModel: BaseViewModel, ViewModelTransformable {
    
    // MARK: - Properties

    private let placeUsecase: PlaceUseCaseable = PlaceUsecaseImplement()
    private let favoriteUsecase: FavoriteUseCaseable = FavoriteUsecaseImplement()
    var places = [Place]()
    var socialNetwork = [Favorite]()
    let city: City
    func transform(input: Input) -> Output {
        return Output(isLoading: loadAPI(input: input).asDriverOnErrorJustComplete(), isSocialLoading: loadSocialNetwork(input: input).asDriverOnErrorJustComplete())
    }
    
    // MARK: - Initialization
    
    init(city: City) {
        self.city = city
    }

    // MARK: - Private Func

    private func loadAPI(input: Input) -> PublishSubject<Bool> {
        guard let placeID = city.placeID else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Place]?, AppError>> in
                self.placeUsecase.loadAPI(with: placeID).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.places = data ?? [Place]()
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    private func loadSocialNetwork(input: Input) -> PublishSubject<Bool> {
        guard let cityID = city.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Favorite]?, AppError>> in
                self.favoriteUsecase.loadAPI(with: cityID, queryType: .city).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.socialNetwork = data ?? [Favorite]()
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

extension CityDetailViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isSocialLoading: Driver<Bool>
    }
}
