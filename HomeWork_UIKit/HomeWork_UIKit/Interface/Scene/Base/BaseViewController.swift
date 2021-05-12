//
//  BaseViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class BaseViewController: UIViewController, Navigateable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    
    func setupData() {
        
    }
    
    func setupUI() {
        
        showNavigationBar(animated: true)
    }
}
