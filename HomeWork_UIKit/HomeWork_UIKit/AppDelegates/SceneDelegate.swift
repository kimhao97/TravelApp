//
//  SceneDelegate.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        window?.makeKeyAndVisible()
        
        ServiceFacade.registerDefaultService(from: window!)
        ServiceFacade.applicationService.applicationRoute(from: window!)
        ServiceFacade.theme.apply()
    }
}
