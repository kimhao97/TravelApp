import UIKit
import netfox
class ApplicationDevelopmentConfiguration: ApplicationConfigurable {
    func applicationRoute(from window: UIWindow) {
        let tabBarViewController = TabBarController(selectedTab: .home)
        setRoot(window: window, view: tabBarViewController)
//        setRoot(window: window, view: UINavigationController(rootViewController: LoginViewController()))
    }
    func setupSpecificConfig() {
        #if DEV
        NFX.sharedInstance().start()
        #endif
    }
    func shutDown() {
        #if DEV
        NFX.sharedInstance().stop()
        #endif
    }
}
