//
//  DetailViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

class DetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        
        title = "Detail"
    }
    
    override func setupData() {
        super.setupData()
        
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Action
    
    @IBAction func backPress(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
