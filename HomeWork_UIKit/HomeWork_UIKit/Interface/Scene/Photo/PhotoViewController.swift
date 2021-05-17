import UIKit
import RxSwift
import RxCocoa
import Then

private enum PhotoConstraints {
    static let photoHeightForRowTableView: CGFloat = 410
    static let loadingHeightForRowTableView: CGFloat = 55
}

final class PhotoViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: PhotoViewModel
    private let disposeBag = DisposeBag()
    private let refreshComment = PublishRelay<Void>()
    private let refreshLike = PublishRelay<Void>()
    // MARK: - Initialization
    
    init() {
        self.viewModel = PhotoViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshComment.accept(())
        refreshLike.accept(())
    }
    override func setupData() {
        super.setupData()
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: PhotoTableViewCell.nib, withCellClass: PhotoTableViewCell.self)
            $0.register(nib: LoadingTableViewCell.nib, withCellClass: LoadingTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigationItem.title = "Photos"
        
        let postButton = UIButton(type: .system)
        postButton.setImage(UIImage(named: "ic-post"), for: .normal)
        postButton.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        
        let postBarItem = UIBarButtonItem(customView: postButton)
        postBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        postBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        postBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.rightBarButtonItem = postBarItem
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = PhotoViewModel.Input(loadPhoto: Driver.just(()), loadComment: refreshComment.asDriverOnErrorJustComplete(), loadLike: refreshLike.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
    
    private func shareSocialMedia(image: UIImage) {
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func deleteActionSheet(with photo: Photo) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete post", style: .destructive) { [weak self] _ in
            self?.viewModel.deletePhoto(with: photo) { done in
                if done {
                    self?.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @objc func postAction() {
        navigate(to: PostPhotoDestination())
    }
}

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.photos.count
        } else if section == 1 && viewModel.photos.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(for: indexPath, cellType: PhotoTableViewCell.self)
                .then {
                    let item = viewModel.photos[indexPath.row]
                    var comments = [Comment]()
                    var likes = [Like]()
                    if let photoID = item.id {
                        comments = viewModel.getComments(with: photoID)
                        likes = viewModel.getLikes(with: photoID)
                        $0.isViewCommentPressed = { [weak self] in
                            self?.navigate(to: CommentDestination(photoID: photoID, comments: comments), present: false)
                        }
                        
                        $0.isShared = { [weak self] image in
                            self?.shareSocialMedia(image: image)
                        }
                        
                        $0.isLiked = { [weak self] isSelected in
                            if isSelected {
                                self?.viewModel.postLike(photoID: photoID) { [weak self] done in
                                    if done {
                                        self?.refreshLike.accept(())
                                    }
                                }
                            } else {
                                self?.viewModel.dislike() { [weak self] done in
                                    if done {
                                        self?.tableView.reloadData()
                                    }
                                }
                            }
                        }
                        
                        $0.isDeleted = { [weak self] in
                            self?.deleteActionSheet(with: item)
                        }
                    }
                    $0.binding(photo: item, isLike: viewModel.isUserLikePhoto(with: likes), comments: comments, likes: likes)
                }
        } else {
            return tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self)
                .then {
                    $0.activityIndicator.startAnimating()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return PhotoConstraints.photoHeightForRowTableView
        } else {
            return PhotoConstraints.loadingHeightForRowTableView
        }
    }
}

extension PhotoViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, done in
            if done {
                view.tableView.reloadData()
            }
        }
    }
}
