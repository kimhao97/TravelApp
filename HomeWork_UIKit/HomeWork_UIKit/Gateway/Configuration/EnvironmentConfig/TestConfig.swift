import UIKit
class ApplicationTestingConfiguration: ApplicationConfigurable {
    func applicationRoute(from window: UIWindow) {
        let tabBarViewController = TabBarController(selectedTab: .home)
        
        setRoot(window: window, view: UINavigationController(rootViewController: tabBarViewController))
    }
    func setupSpecificConfig() {
    }
    func shutDown() {
    }
}
