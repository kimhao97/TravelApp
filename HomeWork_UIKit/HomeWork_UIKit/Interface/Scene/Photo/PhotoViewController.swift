import UIKit
import RxSwift
import RxCocoa
import Then

private enum PhotoConstraints {
    static let photoHeightForRowTableView: CGFloat = .init(458)
    static let loadingHeightForRowTableView: CGFloat = .init(55)
}

final class PhotoViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: PhotoViewModel
    private let disposeBag = DisposeBag()
    private let refreshComment = PublishRelay<Void>()
    
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
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = PhotoViewModel.Input(loadPhoto: Driver.just(()), loadComment: refreshComment.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
        output.isCommentLoading
            .drive(isCommentBinder)
            .disposed(by: disposeBag)
    }
    
    private func shareSocialMedia(image: UIImage) {
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
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
                    if let photoID = item.id {
                        comments = viewModel.getComments(with: photoID)
                        $0.isViewCommentPressed = { [weak self] in
                            self?.navigate(to: CommentDestination(photoID: photoID, comments: comments), present: false)
                            
                        }
                        
                        $0.isShared = { [weak self] image in
                            self?.shareSocialMedia(image: image)
                        }
                        
                        $0.isLiked = { [weak self] isSelected in
                            self?.viewModel.postLike(photoIndex: indexPath.row, isLike: isSelected) { [weak self] done in
                                if done {
                                    self?.tableView.reloadData()
                                }
                            }
                        }
                    }
                    $0.binding(photo: item, comments: comments)
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
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.tableView.reloadData()
            }
        }
    }
    
    private var isCommentBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.tableView.reloadData()
            }
        }
    }
}
