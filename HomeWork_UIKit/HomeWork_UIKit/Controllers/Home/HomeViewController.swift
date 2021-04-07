//
//  HomeViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

final class HomeViewController: BaseViewController {

    @IBOutlet private weak var pageView: UIView!
    
    lazy private var pageViewController: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        
        setupPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Private Func
    
    private func setupPageViewController() {
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = .zero
        
        guard let initialPageController = getPageViewController(index: 0) else { return }
        self.pageViewController.setViewControllers([initialPageController], direction: .forward, animated: false, completion: nil)
        self.addChild(self.pageViewController)
        
        self.pageView.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
       
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageViewController.view.topAnchor.constraint(equalTo: self.pageView.topAnchor).isActive = true
        self.pageViewController.view.leftAnchor.constraint(equalTo: self.pageView.leftAnchor).isActive = true
        self.pageViewController.view.bottomAnchor.constraint(equalTo: self.pageView.bottomAnchor).isActive = true
        self.pageViewController.view.rightAnchor.constraint(equalTo: self.pageView.rightAnchor).isActive = true
    }
    
    private func getPageViewController(index: Int) -> IntructionViewController? {
        let vc = IntructionViewController()
        
        vc.pageIndex = index
        return vc
    }
}

extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let beforePage = viewController as? IntructionViewController else { return nil }
        let beforePageIndex = beforePage.pageIndex
        
        let newIndex = beforePageIndex - 1
        if newIndex < 0 { return nil }
        return getPageViewController(index: newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let afterPage = viewController as? IntructionViewController else { return nil }
        let afterPageIndex = afterPage.pageIndex
        
        let newIndex = afterPageIndex + 1
        if newIndex < 0 { return nil }
        return getPageViewController(index: newIndex)
    }
}
