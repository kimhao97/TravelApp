import Foundation
import RxSwift
import RxCocoa

final class PhotoViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    private var comments = [Comment]()
    var favorites = [Favorite]()
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    private let commentUsecase: CommentUseCaseable = CommentUsecaseImplement()
    
    func transform(input: Input) -> Output {
        return Output(isLoading: loadPhoto(input: input).asDriverOnErrorJustComplete(),
                      isCommentLoading: loadComment(input: input).asDriverOnErrorJustComplete())
    }
    
    func loadPhoto(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadPhoto
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Photo]?, AppError>> in
                self.photoUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.photos = data ?? [Photo]()
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func loadComment(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadComment
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Comment]?, AppError>> in
                self.commentUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.comments = data ?? [Comment]()
                    publishSubject.onNext(false)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(true)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func postLike(photoIndex: Int, isLike: Bool, completion: @escaping (Bool) -> Void) {
        if isLike {
            photos[photoIndex].addLike()
        } else {
            photos[photoIndex].dislike()
        }
       
        photoUsecase.postLike(with: photos[photoIndex]) { result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(_):
                completion(true)
            }
        }
    }
    
    func getComments(with photoID: String) -> [Comment] {
        var commentFiltered = [Comment]()
        for item in comments where item.photoID == photoID {
            commentFiltered.append(item)
        }
        return commentFiltered
    }
}

extension PhotoViewModel {
    struct Input {
        let loadPhoto: Driver<Void>
        let loadComment: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let isCommentLoading: Driver<Bool>
    }
}
