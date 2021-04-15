//
//  SignUpViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/14/21.
//

import UIKit

class SignUpViewController: BaseViewController {

    let viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
