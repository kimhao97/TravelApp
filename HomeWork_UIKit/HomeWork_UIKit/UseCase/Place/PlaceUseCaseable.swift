import Foundation
import RxCocoa
import RxSwift

protocol PlaceUseCaseable: class {
    func loadAPI(with placeID: String) -> Observable<Result<[Place]?, AppError>>
}

class PlaceUsecaseImplement: PlaceUseCaseable {
    let placeService: PlaceServiceable
    
    init(placeService: PlaceServiceable = PlaceServiceImplement()) {
        self.placeService = placeService
    }
    
    func loadAPI(with placeID: String) -> Observable<Result<[Place]?, AppError>> {
        return Observable.create({ (signal) -> Disposable in
            self.placeService.loadAPI(with: placeID) { (data, error) in
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
