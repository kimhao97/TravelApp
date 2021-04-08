//
//  ImageViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/8/21.
//

import UIKit

private enum ImageContraints {
    static let heightForRow: CGFloat = 80
}

final class ImageViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupData() {
        super.setupData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ImageTableViewCell.nib(),
                         forCellReuseIdentifier: ImageTableViewCell.identifer)
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
}

extension ImageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifer,
                                                      for: indexPath) as? ImageTableViewCell else { return ImageTableViewCell() }
        let title = "Image \(indexPath.row)"
        cell.binding(title: title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ImageContraints.heightForRow
    }
    
}
