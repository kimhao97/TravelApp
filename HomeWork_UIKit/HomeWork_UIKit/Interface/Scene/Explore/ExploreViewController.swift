import UIKit
import Then
import Reusable
import RxSwift
import RxCocoa
import AnimatedCollectionViewLayout

private enum ExploreConstrains {
    static let sizeForCellCollectionView: CGSize = .init(width: 269, height: 390)
}

final class ExploreViewController: BaseViewController {
     
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let layout = AnimatedCollectionViewLayout()
    private let disposeBag = DisposeBag()
    private let viewModel: ExploreViewModel!
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = ExploreViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func setupData() {
        super.setupData()
        
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(nib: ExploreCollectionViewCell.nib, forCellWithClass: ExploreCollectionViewCell.self)
        }
        
        bindViewModel()
    }
    
    override func setupUI() {
        super.setupUI()
        
        layout.animator = LinearCardAttributesAnimator(minAlpha: 0.1, itemSpacing: 0, scaleRate: 1)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = ExploreViewModel.Input(load: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cities.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(for: indexPath, cellType: ExploreCollectionViewCell.self)
            .then {
                let item = viewModel.cities.value[indexPath.row]
                $0.biding(city: item)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.cities.value[indexPath.row]
        navigate(to: CityDetailDestination(city: item), present: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ExploreConstrains.sizeForCellCollectionView
    }
    
//    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
//        let totalWidth = cellWidth * numberOfItems
//        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
//        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth =  ExploreConstrains.sizeForCellCollectionView.width.int * viewModel.cities.value.count
//        let totalSpacingWidth = 10 * (3 - 1)
//
//        let leftInset = (collectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
}

extension ExploreViewController {
    private var isLoadingBinder: Binder<Bool> {
        return Binder(self) { view, isloading in
            if isloading {
                
            } else {
                view.collectionView.reloadData()
            }
        }
    }
}
