import UIKit
import RxSwift
import RxCocoa

private enum SearchDetailConstraints {
    static let heightForRowResultSearchTableView: CGFloat = 170
}

class SearchDetailViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!

    private let viewModel: SearchDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = SearchDetailViewModel()
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
            $0.register(nib: ResultTableViewCell.nib, withCellClass: ResultTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        hideNavigationBar(animated: false)
    }
    
    // MARK: - Private Function
    
    private func bindViewModel() {
        let input = SearchDetailViewModel.Input(query: searchTextField.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func back(sender: Any) {
        navigationController?.popViewController()
    }
}

extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: ResultTableViewCell.self)
            .then {
                let item = viewModel.photos[indexPath.row]
                $0.selectionStyle = .none
                $0.binding(photo: item)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchDetailConstraints.heightForRowResultSearchTableView
    }
}

extension SearchDetailViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, _ in
            view.tableView.reloadData()
        }
    }
}
