//
//  LibraryViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

private enum LibraryConstraints {
    static let insetForSection: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
}

final class LibraryViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupData() {
        super.setupData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LibraryCollectionViewCell.nib(),
                             forCellWithReuseIdentifier: LibraryCollectionViewCell.identifer)
    }
    
    override func setupUI() {
        super.setupUI()
        
        showNavigationBar(animated: false)
        self.navigationItem.title = "Library"
    }
}

extension LibraryViewController: UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifer,
                                                            for: indexPath) as? LibraryCollectionViewCell else { return LibraryCollectionViewCell() }
        
        
        cell.binding(title: "Name \(indexPath.row)")
        
        cell.isDetailPress = { [weak self] isPress in
            if isPress {
                let title = "Cell \(indexPath.row)"
                print(title)
                
                let vc = DetailViewController(title: title)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let vc = ImageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2 - 20), height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return LibraryConstraints.insetForSection
    }
}
