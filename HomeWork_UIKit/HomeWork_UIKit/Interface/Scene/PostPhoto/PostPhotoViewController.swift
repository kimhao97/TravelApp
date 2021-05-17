import UIKit
import RxSwift
import RxCocoa

final class PostPhotoViewController: BaseViewController {
    
    @IBOutlet private weak var postTextField: UITextField!
    @IBOutlet private weak var photoImage: UIImageView!

    private let imagePickerVC = UIImagePickerController()
    private let viewModel: PostPhotoViewModel
    private var saveTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    // MARK: - Initialization
    
    init() {
        self.viewModel = PostPhotoViewModel()
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
        navigationItem.title = "Create Post"
        
        let saveButton = UIButton(type: .system)
        saveButton.setImage(UIImage(named: "ic-checkmark"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setImage(UIImage(named: "ic-cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let saveBarItem = UIBarButtonItem(customView: saveButton)
        saveBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        saveBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        saveBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        let cacnelBarItem = UIBarButtonItem(customView: cancelButton)
        cacnelBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        cacnelBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        cacnelBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = cacnelBarItem
        navigationItem.rightBarButtonItem = saveBarItem
    }
    
    private func bindViewModel() {
        let postInfor = Driver.combineLatest(postTextField.value(),
                                             photoImage.value()) {
            (postText: $0, image: $1)
        }
        
        let input = PostPhotoViewModel.Input(saveTrigger: saveTrigger.asDriverOnErrorJustComplete(), postInfor: postInfor)
        
        let output = viewModel.transform(input: input)
        output.isCteated
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

extension PostPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            photoImage.image = image
        }
    }
}
