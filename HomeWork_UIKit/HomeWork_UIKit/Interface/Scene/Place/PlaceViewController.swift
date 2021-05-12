import UIKit
import RxSwift
import RxCocoa
import Then

private enum PlaceConstraints {
    static let sizeForCellCollectionView: CGSize = .init(width: 60, height: 68)
    static let heightForRowTableView: CGFloat = .init(82)
}

class PlaceViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var placeImage: UIImageView!
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var nameLikedLabel: UILabel!
    @IBOutlet private weak var nameMoreLabel: UILabel!
    @IBOutlet private weak var avatar1Image: UIImageView!
    @IBOutlet private weak var avatar2Image: UIImageView!
    @IBOutlet private weak var avatar3Image: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    
    private let viewModel: PlaceViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(place: Place) {
        self.viewModel = PlaceViewModel(place: place)
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
            $0.register(nib: PhotoCollectionViewCell.nib, forCellWithClass: PhotoCollectionViewCell.self)
        }
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: SpotTableViewCell.nib, withCellClass: SpotTableViewCell.self)
        }
        bindViewModel() 
    }
    
    override func setupUI() {
        super.setupUI()
        
        hideNavigationBar(animated: false)
        
        let place = viewModel.place
        placeNameLabel.text = place.name
        descriptionTextView.text = place.description
        if let urlString = place.photo {
            placeImage.imageFromURL(path: urlString)
        }
    }

    private func bindViewModel() {
        let input = PlaceViewModel.Input(load: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
        
        output.isFavoriteLoading
            .drive(isFavoriteBinder)
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

// MARK: - Photos

extension PlaceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCollectionViewCell.self)
            .then {
                let item = viewModel.photos.value[indexPath.row]
                $0.binding(photo: item)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PlaceConstraints.sizeForCellCollectionView
    }
}

// MARK: - Featured Spots

extension PlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.featuredSpots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: SpotTableViewCell.self)
            .then {
                let item = viewModel.featuredSpots[indexPath.row]
                let likes = viewModel.getNumberOfLikes(spot: item)
                $0.binding(place: item, with: likes)
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceConstraints.heightForRowTableView
    }
}

// MARK: - Binder

extension PlaceViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.collectionView.reloadData()
            }
        }
    }
    
    private var isFavoriteBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.tableView.reloadData()
                
                let items = self.viewModel.favorites
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
