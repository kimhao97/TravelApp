import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var websiteTextField: UITextField!
    
    private let imagePickerVC = UIImagePickerController()
    private let viewModel: EditProfileViewModel
    private var saveTrigger = PublishSubject<Void>()
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
        
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        showNavigationBar(animated: false)
        
        navigationItem.title = "Edit Profile"
        let cancelButton = UIBarButtonItem(image: UIImage(named: "ic-cancel"), style: .plain, target: self, action: #selector(backAction))
        let saveButton = UIBarButtonItem(image: UIImage(named: "ic-checkmark"), style: .plain, target: self, action: #selector(saveAction))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        let profile = viewModel.profile
        usernameTextField.text = profile.userName
        websiteTextField.text = profile.website
        addressTextField.text = profile.address
        if let imageUrl = profile.avatarUrl {
            avatarImage.imageFromURL(path: imageUrl)
            viewModel.profile.setAvatar(image: avatarImage.image)
        }
    }
    
    private func bindViewModel() {
        let profileInfor = Driver.combineLatest(usernameTextField.value(),
                                         websiteTextField.value(),
                                         addressTextField.value(),
                                         avatarImage.value()) {
            (userName: $0, website: $1, address: $2, avatar: $3)
        }
        
        let input = EditProfileViewModel.Input(saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), profileInfor: profileInfor)
        
        let output = viewModel.transform(input: input)
        output.isSaved
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func saveAction() {
        saveTrigger.onNext(())
    }
    
    // MARK: - Action
    
    @IBAction func selectImage(sender: Any) {
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            avatarImage.image = image
        }
    }
}
