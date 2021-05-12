import Foundation
import RxCocoa
import RxSwift

protocol ExploreUseCaseable: class {
    func loadAPI() -> Observable<Result<[City]?, AppError>>
    func loadLiked(with cityID: String) -> Observable<Result<[Favorite]?, AppError>>
}

class ExploreUsecaseImplement: ExploreUseCaseable {
    let exploreService: ExploreServiceable
    let favoriteService: FavoriteServiceable
    
    init(exploreService: ExploreServiceable = ExploreServiceImplement(),
         favoriteService: FavoriteServiceable = FavoriteServiceImplement()) {
        self.exploreService = exploreService
        self.favoriteService = favoriteService
    }
    
    func loadAPI() -> Observable<Result<[City]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.exploreService.loadAPI() { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
    
    func loadLiked(with cityID: String) -> Observable<Result<[Favorite]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.favoriteService.loadAPI(with: cityID, queryType: .city) { (data, error) in
                if let error = error {
                    signal.onNext(.failure(error))
                } else {
                    signal.onNext(.success(data?.result))
                }
                signal.on(.completed)
            }
            return Disposables.create()
        })
    }
}
