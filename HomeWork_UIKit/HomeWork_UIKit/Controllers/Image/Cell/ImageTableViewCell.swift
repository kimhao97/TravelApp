//
//  ImageTableViewCell.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/8/21.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifer: String = "ImageTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ImageTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = "..."
        cellImage.image = UIImage(named: "ic-noImage")
        activityIndicator.startAnimating()
    }
    
    // MARK: - Public Func
    
    func binding(title: String) {
        self.titleLabel.text = title
                
        if let url = URL(string: "https://wallpapercave.com/wp/wp2670841.jpg") {
            cellImage.downloaded(from: url) { [weak self]done in
                if done {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.hidesWhenStopped = true
                }
            }
        }
    }
    
}
