//
//  LoginDestinations.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import UIKit

// MARK: - Destination

class LoginDestination: Destinating {
    var view: UIViewController {
        return LoginViewController()
    ()}
}

class LoginCompleteDestination: Destinating {
    let tabBarViewController = TabBarController(selectedTab: .home)
    var view: UIViewController {
        return tabBarViewController
    }
}

class SignUpDestination: Destinating {
    var view: UIViewController {
        return SignUpViewController(viewModel: SignUpViewModel())
    }
}
