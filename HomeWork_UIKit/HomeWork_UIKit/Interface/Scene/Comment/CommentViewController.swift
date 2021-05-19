import UIKit
import RxSwift
import RxCocoa

final class CommentViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var avatarImage: UIImageView!
    
    private let viewModel: CommentViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(photoID: String, comments: [Comment]) {
        self.viewModel = CommentViewModel(photoID: photoID, comments: comments)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupData() {
        super.setupData()
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: CommentTableViewCell.nib, withCellClass: CommentTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigationItem.title = "Comments"
        postButton.titleLabel?.font = AppFont.appFont(type: .regular, fontSize: 14)
        let backButton = UIBarButtonItem(image: UIImage(named: "ic-back"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backButton
        
        if let imageUrl = viewModel.getAvatarUrl() {
            avatarImage.imageFromURL(path: imageUrl)
        }
    }
    
    private func bindViewModel() {
        let commentText = commentTextField.driver()
        let submit = postButton.driver()
        let input = CommentViewModel.Input(comment: commentText, commentTrigger: submit)
        
        let output = viewModel.transform(input: input)
        output.isCommentPosted
            .drive(isCommentBinder)
            .disposed(by: disposeBag)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: CommentTableViewCell.self)
            .then {
                let item = viewModel.comments[indexPath.row]
                $0.binding(comment: item)
            }
    }
}

extension CommentViewController {
    private var isCommentBinder: Binder<Bool> {
        return Binder(self) { view, isPosted in
            if isPosted {
                view.commentTextField.text = .none
                view.tableView.reloadData()
            } else {
                
            }
        }
    }
}
