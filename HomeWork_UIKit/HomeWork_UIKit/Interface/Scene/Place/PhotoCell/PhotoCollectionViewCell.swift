import UIKit
import Reusable

class PhotoCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var photoImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func binding(photo: Photo) {
        if let urlString = photo.imageUrl {
            photoImage.imageFromURL(path: urlString)
        }
    }

}
