//
//  LoginViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import UIKit

class LoginViewController: BaseViewController {
    
//    @IBOutlet private weak var userTextField: UITextField!
//    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Action
    
    @IBAction func signIn(_ sender: Any) {
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        navigate(to: SignUpDestination(), present: false)
    }
}
