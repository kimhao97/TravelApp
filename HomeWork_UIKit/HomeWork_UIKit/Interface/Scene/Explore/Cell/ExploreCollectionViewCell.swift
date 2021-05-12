import UIKit
import Reusable

final class ExploreCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var countryImage: UIImageView!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func biding(city: City) {
        countryLabel.text = city.name
        placeLabel.text = " \(city.numberOfPlace ?? "0") places to visit"
        if let imageUrl = city.photo {
            countryImage.imageFromURL(path: imageUrl)
        }
    }
}
