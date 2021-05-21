import Foundation
import UIKit

class SearchDetailDestination: Destinating {
    var view: UIViewController {
        return SearchDetailViewController()
    }
}

class SearchLocationDestination: Destinating {
    var view: UIViewController {
        return SearchLocationViewController()
    }
}
