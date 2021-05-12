//
import UIKit
import Reusable

class SpotTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var spotImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding(place: Favorite, with likes: Int) {
        titleLabel.text = place.placeName
        descriptionLabel.text = "\(likes) like"
        
        if let urlString = place.placePhoto {
            spotImage.imageFromURL(path: urlString)
        }
    }
}
