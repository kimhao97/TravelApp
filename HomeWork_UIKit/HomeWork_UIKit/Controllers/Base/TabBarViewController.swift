//
//  TabBarViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Initialize
    convenience init(selectedTab: TabBarType) {
        self.init()
        setupData()
        selectedIndex = selectedTab.rawValue
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configUI()
    }
}

// MARK: - Private Func

extension TabBarController {
    private func configUI() {
        tabBar.isTranslucent = false
        tabBar.tintColor = .red
    }
    
    private func setupData() {
        var  navigationController = [UINavigationController]()
        
        TabBarType.allCases.forEach { item in
            let navigationItem = UINavigationController(rootViewController: item.viewController)
            navigationItem.tabBarItem = TabBarItem(title: item.title, image: item.image, selectedImage: nil)
            navigationController.append(navigationItem)
        }
        
        setViewControllers(navigationController, animated: true)
    }
}

// MARK: - Enum

extension TabBarController {
    enum TabBarType: Int, CaseIterable {
        case home
        case library
        case profile
        
        var title: String {
            switch self {
            case .home:
                return ""
            case .library:
                return ""
            case .profile:
                return ""
            }
        }
        
        var image: UIImage? {
            switch self {
            case .home:
                return UIImage(named: "ic-home")
            case .library:
                return UIImage(named: "ic-library")
            case .profile:
                return UIImage(named: "ic-profile")
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .home:
                return HomeViewController()
            case .library:
                return LibraryViewController()
            case .profile:
                return ProfileViewController()
            }
        }
    }
}
