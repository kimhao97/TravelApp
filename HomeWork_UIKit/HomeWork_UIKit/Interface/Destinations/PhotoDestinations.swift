import UIKit

final class CommentDestination: Destinating {
    
    let comments: [Comment]
    let photoID: String
    init(photoID: String, comments: [Comment]) {
        self.comments = comments
        self.photoID = photoID
    }
    
    var view: UIViewController {
        return CommentViewController(photoID: photoID, comments: comments)
    }
}

final class PostPhotoDestination: Destinating {
    var view: UIViewController {
        return PostPhotoViewController()
    }
}
