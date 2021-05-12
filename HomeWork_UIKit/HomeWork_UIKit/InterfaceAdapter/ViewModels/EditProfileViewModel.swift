import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: BaseViewModel {
    
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
}
