import UIKit
import RxSwift
import RxCocoa
import Then

private enum PhotoConstraints {
    static let heightForRowTableView: CGFloat = .init(458)
}
class PhotoViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: PhotoViewModel
    private let disposeBag = DisposeBag()
    
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
    
    override func setupData() {
        super.setupData()
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: PhotoTableViewCell.nib, withCellClass: PhotoTableViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        
    }
}

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: PhotoTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PhotoConstraints.heightForRowTableView
    }
}
