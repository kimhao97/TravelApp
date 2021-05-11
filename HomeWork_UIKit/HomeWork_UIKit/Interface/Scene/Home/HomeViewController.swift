//
//  HomeViewController.swift
//  HomeWork_UIKit
//
//  Created by Kim Hao on 4/6/21.
//

import UIKit

final class HomeViewController: BaseViewController {
    @IBOutlet private weak var pageView: UIView!

    private lazy var pageViewController: UIPageViewController = {
        UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
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

        hideNavigationBar(animated: false)
    }

    deinit {
        logDeinit()
    }

    // MARK: - Private Func

    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.frame = .zero

        guard let initialPageController = getPageViewController(index: 0) else { return }
        pageViewController.setViewControllers([initialPageController], direction: .forward, animated: false, completion: nil)
        addChild(pageViewController)

        pageView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: pageView.topAnchor).isActive = true
        pageViewController.view.leftAnchor.constraint(equalTo: pageView.leftAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: pageView.bottomAnchor).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: pageView.rightAnchor).isActive = true
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
