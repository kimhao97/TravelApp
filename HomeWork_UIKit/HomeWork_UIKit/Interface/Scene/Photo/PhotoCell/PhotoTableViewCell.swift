import UIKit
import Reusable
import Kingfisher

class PhotoTableViewCell: UITableViewCell, NibReusable {
    
    // MARK: - Properties

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var commentLabel: UITextView!
    @IBOutlet private weak var seeAllCommentButton: UIButton!
    
    var isViewCommentPressed: (() -> Void)?
    var isShared: ((UIImage) -> Void)?
    var isLiked: ((Bool) -> Void)?
    private var photo: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Publish Func
    
    func binding(photo: Photo, comments: [Comment]) {
        self.photo = photo
        userNameLabel.text = photo.userName
        if let like = Int(photo.like ?? "0") {
            likeLabel.text = "\(like)" + (like == 0 ? " like" : " likes")
        }
        
        if let avatarUrl = photo.avatarUrl {
            userImage.imageFromURL(path: avatarUrl)
        }
        if let photoUrl = photo.imageUrl {
            thumbnail.imageFromURL(path: photoUrl)
        }
        if let comment = comments.last {
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
        
        seeAllCommentButton.setTitle("See \(comments.count) comments", for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func likeAction(sender: Any) {
        likeButton.isSelected.toggle()
        isLiked?(likeButton.isSelected)
    }
    
    @IBAction func shareAction(sender: Any) {
        if let image = getImageCached() {
            isShared?(image)
        }
    }
    
    @IBAction func seeCommentsAction(sender: Any) {
        isViewCommentPressed?()
    }
    
    // MARK: - Private Func
    
    func getImageCached() -> UIImage? {
        if let path = photo?.imageUrl {
            let isImageCached = ImageCache.default.imageCachedType(forKey: path)
            if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
                return image
            }
        }
        return nil
    }
}
