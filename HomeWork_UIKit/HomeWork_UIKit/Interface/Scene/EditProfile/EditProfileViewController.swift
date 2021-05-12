import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var websiteTextField: UITextField!
    private let viewModel: EditProfileViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(profile: Profile) {
        self.viewModel = EditProfileViewModel(profile: profile)
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
    }
    
    override func setupUI() {
        super.setupUI()
        
        let profile = viewModel.profile
        
        nameTextField.text = profile.name
        usernameTextField.text = profile.userName
        websiteTextField.text = profile.website
        addressTextField.text = profile.address
    }
}
