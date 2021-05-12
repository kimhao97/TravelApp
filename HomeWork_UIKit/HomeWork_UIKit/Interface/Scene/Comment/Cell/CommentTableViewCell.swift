import UIKit
import Reusable

final class CommentTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func binding(comment: Comment) {
        if let avatarUrl = comment.avatarUrl {
            avatarImage.imageFromURL(path: avatarUrl)
        }
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
        ]
        let regularAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        ]
        let boldText = NSAttributedString(string: comment.userName ?? "", attributes: boldAttribute)
        let regularText = NSAttributedString(string: " " + (comment.content ?? ""), attributes: regularAttribute)
        let newString = NSMutableAttributedString()
        newString.append(boldText)
        newString.append(regularText)
        commentLabel.attributedText = newString
    }
}
