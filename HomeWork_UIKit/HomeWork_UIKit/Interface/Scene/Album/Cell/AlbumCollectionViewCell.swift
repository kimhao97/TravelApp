import UIKit
import Reusable

class AlbumCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binding(with name: String, photos: [Photo]) {
        nameLabel.text = name
        if photos.count > 0 {
            numberLabel.text = "\(photos.count) photos"
        } else {
            numberLabel.text = "Empty"
        }
        
        if let imageUrl = photos.last?.imageUrl {
            photo.imageFromURL(path: imageUrl)
        }
    }

}
