import UIKit
import RxSwift
import RxCocoa
import Then

private enum CityDetailConstraints {
    static let sizeForCellCollectionView: CGSize = .init(width: 150, height: 98)
}

class CityDetailViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLikedLabel: UILabel!
    @IBOutlet private weak var nameMoreLabel: UILabel!
    @IBOutlet private weak var avatar1Image: UIImageView!
    @IBOutlet private weak var avatar2Image: UIImageView!
    @IBOutlet private weak var avatar3Image: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    private let viewModel: CityDetailViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(city: City) {
        self.viewModel = CityDetailViewModel(city: city)
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
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: CityDetailCollectionViewCell.nib, forCellWithClass: CityDetailCollectionViewCell.self)
            $0.backgroundColor = .clear
        }
        
        bindViewModel() 
    }
    
    override func setupUI() {
        super.setupUI()
        
        let item = viewModel.city
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        regionLabel.text = item.region
        if let urlString = item.photo {
            backgroundImage.imageFromURL(path: urlString)
        }
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = CityDetailViewModel.Input(load: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
        output.isSocialLoading
            .drive(isSocialLoading)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action
    
    @IBAction func liked(sender: Any) {
        likeButton.isSelected.toggle()
        
        if likeButton.isSelected {
            
        } else {
            
        }
    }
}

extension CityDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(for: indexPath, cellType: CityDetailCollectionViewCell.self)
            .then {
                let item = viewModel.places[indexPath.row]
                $0.binding(place: item)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.places[indexPath.row]
        navigate(to: PlaceDestination(place: item), present: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CityDetailConstraints.sizeForCellCollectionView
    }
}

extension CityDetailViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.collectionView.reloadData()
            }
        }
    }
    
    private var isSocialLoading: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                let items = self.viewModel.socialNetwork
                let count = items.count
                
                switch count {
                case 0:
                    break
                case 1:
                    view.nameLikedLabel.text = "\(items[0].userName ?? "")"
                    if let urlString = items[0].userPhoto {
                        view.avatar1Image.imageFromURL(path: urlString)
                    }
                case 2:
                    view.nameLikedLabel.text = "\(items[0].userName ?? ""), \(items[1].userName ?? "")"
                    if let urlString1 = items[0].userPhoto, let urlString2 = items[1].userPhoto {
                        view.avatar1Image.imageFromURL(path: urlString1)
                        view.avatar2Image.imageFromURL(path: urlString2)
                    }
                default:
                    self.nameLikedLabel.text = "\(items[0].userName ?? ""), \(items[1].userName ?? ""), \(items[2].userName ?? "")"
                    if count > 3 {
                        view.nameMoreLabel.isHidden = false
                        view.nameMoreLabel.text = "and \(items.count - 3) people like this"
                    }
                    
                    if let urlString1 = items[0].userPhoto, let urlString2 = items[1].userPhoto, let urlString3 = items[2].userPhoto {
                        view.avatar1Image.imageFromURL(path: urlString1)
                        view.avatar2Image.imageFromURL(path: urlString2)
                        view.avatar3Image.imageFromURL(path: urlString3)
                    }
                }
            }
        }
    }
}
