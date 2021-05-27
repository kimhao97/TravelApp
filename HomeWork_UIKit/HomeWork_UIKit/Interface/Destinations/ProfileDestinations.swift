import UIKit

final class PhotoDetailDestination: Destinating {
    
    let photos: [Photo]
    let isHideNavigationBar: Bool
    init(photos: [Photo], isHideNavigationBar: Bool) {
        self.photos = photos
        self.isHideNavigationBar = isHideNavigationBar
    }
    
    var view: UIViewController {
        return PhotoDetailViewController(photos: photos, isHideNavigationbar: isHideNavigationBar)
    }
}

final class EditProfileDestination: Destinating {
    
    let profile: Profile
    init(profile: Profile) {
        self.profile = profile
    }
    
    var view: UIViewController {
        let vc = EditProfileViewController(profile: profile)
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
