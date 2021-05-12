import Foundation
import RxSwift
import RxCocoa

final class PlaceViewModel: BaseViewModel, ViewModelTransformable {
    
    var place: Place
    var favorites = [Favorite]()
    var featuredSpots = [Favorite]()
    var photos = BehaviorRelay<[Photo]>.init(value: [Photo]())
    private let placeUsecase: PlaceUseCaseable = PlaceUsecaseImplement()
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    private let favoriteUsecase: FavoriteUseCaseable = FavoriteUsecaseImplement()
    
    // MARK: - Initialization
    
    init(place: Place) {
        self.place = place
    }
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete(),
                      isFavoriteLoading: loadFavorite(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        guard let placeID = place.id else { return PublishSubject<Bool>()}
        
        let publishSubject = PublishSubject<Bool>()
        input
            .load
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: placeID, queryType: .place).asDriverOnErrorJustComplete()            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.photos.accept(data ?? [Photo]())
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func loadFavorite(input: Input) -> PublishSubject<Bool> {
        guard let cityID = place.cityID else { return PublishSubject<Bool>()}
        
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
                    self.favorites = data ?? [Favorite]()
                    self.getFeaturedSpots()
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func getFeaturedSpots() {
        favorites.forEach { [weak self] item in
            guard let self = self else { return }
            if featuredSpots.contains(item) == false {
                self.featuredSpots.append(item)
            }
        }
    }
    
    func getNumberOfLikes(spot: Favorite) -> Int {
        var counter: Int = 0
        
        favorites.forEach { item in
            if spot == item {
                counter += 1
            }
        }
        return counter
    }
}

extension PlaceViewModel {
    struct Input {
        let load: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isFavoriteLoading: Driver<Bool>
//        let isSocialLoading: Driver<Bool>
    }
}
