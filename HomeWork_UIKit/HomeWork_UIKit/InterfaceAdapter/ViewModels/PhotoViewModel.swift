import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseStorage

final class PhotoViewModel: BaseViewModel, ViewModelTransformable {
    
    var photos = [Photo]()
    var likes = [Like]()
    private var comments = [Comment]()
    var favorites = [Favorite]()
    private var persistentDataProvider: PersistentDataSaveable? {
        return ServiceFacade.getService(PersistentDataSaveable.self)
    }
    private let photoUsecase: PhotoUseCaseable = PhotoUsecaseImplement()
    private let commentUsecase: CommentUseCaseable = CommentUsecaseImplement()
    private let likeUsecase: LikeUseCaseable = LikeUsecaseImplement()

    func transform(input: Input) -> Output {
        let output = Driver.merge(loadPhoto(input: input).asDriverOnErrorJustComplete(),
                                  loadLike(input: input).asDriverOnErrorJustComplete(),
                                  loadComment(input: input).asDriverOnErrorJustComplete())
        return Output(isLoading: output)
    }
    
    // MARK: - LoadAPI
    
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
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
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
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    func loadLike(input: Input) -> PublishSubject<Bool> {
        let publishSubject = PublishSubject<Bool>()
        input
            .loadLike
            .flatMapLatest { [unowned self] _ -> Driver<Result<[Like]?, AppError>> in
                self.likeUsecase.loadAPI(with: "", queryType: .none).asDriverOnErrorJustComplete()
            }
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.likes = data ?? [Like]()
                    publishSubject.onNext(true)
                case .failure(let error):
                    self.apiError.onNext(error)
                    publishSubject.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        return publishSubject
    }
    
    // MARK: - Post
    
    func postPhoto(image: UIImage?, postText: String, completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return }

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        let username = persistentDataService.getItem(fromKey: Notification.Name.userName.rawValue) as! String
        let avatarUrl = persistentDataService.getItem(fromKey: Notification.Name.avatarUrl.rawValue) as! String
        
        let filename = UUID().uuidString
        let photoID = UUID().uuidString
        if let data = image?.jpegData(compressionQuality: 0.3) {
            let storage = Storage.storage().reference().child("posts").child(filename)
            storage.putData(data, metadata: nil) { [unowned self] (_, error) in
                guard error == nil else {
                    completion(false)
                    return
                }
                storage.downloadURL { [unowned self] (url, error) in
                    if let imageUrl = url?.absoluteString {
                        let photo = Photo(id: photoID, placeID: "111", cityID: nil, userID: uid, userName: username, avatarUrl: avatarUrl, like: "0", commentID: photoID, imageUrl: imageUrl, region: "Miền Trung", placeName: "Đà Nẵng", width: nil, height: "320")
                        
                        photoUsecase.postPhoto(with: photo) { result in
                            switch result {
                            case .failure(_):
                                completion(false)
                            case .success(_):
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func postLike(photoID: String, completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        let likeObj = Like(id: nil, userID: uid, photoID: photoID)
        likeUsecase.postLike(with: likeObj) { result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(_):
                completion(true)
            }
        }
    }
    
    // MARK: - Delete
    
    func deletePhoto(with photo: Photo, completion: @escaping (Bool) -> Void) {
        photoUsecase.deletePhoto(with: photo) { [unowned self] result in
            switch result {
            case .failure(_):
                completion(false)
            case .success(_):
                self.photos = self.photos.filter { $0.id != photo.id}
                completion(true)
            }
        }
    }
    
    func dislike(completion: @escaping (Bool) -> Void) {
        guard let persistentDataService = persistentDataProvider else { return}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        for item in likes where item.userID == uid {
            likeUsecase.dislike(with: item) { [unowned self] result in
                switch result {
                case .failure(_):
                    completion(false)
                case .success(_):
                    self.likes = self.likes.filter { $0.id != item.id}
                    completion(true)
                }
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
    
    func getLikes(with photoID: String) -> [Like] {
        var likeFiltered = [Like]()
        for item in likes where item.photoID == photoID {
            likeFiltered.append(item)
        }
        return likeFiltered
    }
    
    func isUserLikePhoto(with likes: [Like]) -> Bool {
        guard let persistentDataService = persistentDataProvider else { return false}

        let uid = persistentDataService.getItem(fromKey: Notification.Name.id.rawValue) as! String
        for item in likes where item.userID == uid {
            return true
        }
        return false
    }
}

extension PhotoViewModel {
    struct Input {
        let loadPhoto: Driver<Void>
        let loadComment: Driver<Void>
        let loadLike: Driver<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
    }
}
