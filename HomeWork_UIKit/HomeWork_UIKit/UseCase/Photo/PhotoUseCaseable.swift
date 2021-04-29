import Foundation
import RxCocoa
import RxSwift

protocol PhotoUseCaseable: class {
    func loadAPI(with PhotoID: String, queryType: QueryType) -> Observable<Result<[Photo]?, AppError>>
//    func loadLiked(with PhotoID: String, queryType: QueryType) -> Observable<Result<[Favorite]?, AppError>>
}

class PhotoUsecaseImplement: PhotoUseCaseable {
    let photoService: PhotoServiceable
    let favoriteService: FavoriteServiceable
    
    init(PhotoService: PhotoServiceable = PhotoServiceImplement(),
         favoriteService: FavoriteServiceable = FavoriteServiceImplement()) {
        self.photoService = PhotoService
        self.favoriteService = favoriteService
    }
    
    func loadAPI(with photoID: String, queryType: QueryType) -> Observable<Result<[Photo]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.photoService.loadAPI(with: photoID, queryType: queryType) { (data, error) in
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
