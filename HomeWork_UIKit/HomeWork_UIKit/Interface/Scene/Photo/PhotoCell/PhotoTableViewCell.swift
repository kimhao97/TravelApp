import UIKit
import Reusable

class PhotoTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var photo: UIImageView!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var nameCommentLabel: UILabel!
    @IBOutlet private weak var contentCommentLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binding () {
        
    }
    
    // MARK: - Action
    
    @IBAction func likeAction(sender: Any) {
        
    }
    
    @IBAction func commentAction(sender: Any) {
        
    }
    
    @IBAction func shareAction(sender: Any) {
        
    }
    
    @IBAction func seeCommentsAction(sender: Any) {
        
    }
}
