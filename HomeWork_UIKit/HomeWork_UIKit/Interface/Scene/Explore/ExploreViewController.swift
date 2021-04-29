import UIKit
import Then
import Reusable
import RxSwift
import RxCocoa

private enum ExploreConstrains {
    static let sizeForCellCollectionView: CGSize = .init(width: 269, height: 390)
}

final class ExploreViewController: BaseViewController {
     
    // MARK: - Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
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
//        scrollToOffset()
    }
    
    // MARK: - Private Func
    
    private func bindViewModel() {
        let input = ExploreViewModel.Input(load: Driver.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(isLoadingBinder)
            .disposed(by: disposeBag)
    }
    
//    private func scrollToOffset() {
//        let newOffset = CGPoint(x: 0, y: (collectionView.contentInset.top +  collectionView.width/4))
//        collectionView.setContentOffset(newOffset, animated: true)
////        collectionView.contentInset
//    }
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let sideInset = ExploreConstrains.sizeForCellCollectionView.width/4
//        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
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
