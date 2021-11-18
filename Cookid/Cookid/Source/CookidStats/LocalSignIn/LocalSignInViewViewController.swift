//
//  LocalSignInViewViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class LocalSignInViewViewController: UIPageViewController {
    
    let serviceProvider: ServiceProviderType
    let coordinator: LocalSignInCoordinator
    var pages = [UIViewController]()
    let pagesControl = UIPageControl()
    let initialPage = 0
    
    init(coordinator: LocalSignInCoordinator,
         serviceProvider: ServiceProviderType) {
        self.coordinator = coordinator
        self.serviceProvider = serviceProvider
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupPageControl()
    }
    
    private func setupPages() {
        
        self.dataSource = self
        self.delegate = self
        
        let viewModel = LocalSignInViewModel(serviceProvider: serviceProvider)
        
        var firstPage = FirstPageViewController.instantiate(storyboardID: "Main")
        firstPage.bind(viewModel: viewModel)
        
        var secondPage = SecondPageViewController.instantiate(storyboardID: "Main")
        secondPage.bind(viewModel: viewModel)
        
        var thirdPage = ThirdPageViewController.instantiate(storyboardID: "Main")
        thirdPage.bind(viewModel: viewModel)
        
        var fourthPage = FourthPageViewController.instantiate(storyboardID: "Main")
        fourthPage.bind(viewModel: viewModel)
        fourthPage.coordinator = coordinator
        
        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)
        pages.append(fourthPage)
        
        // 이 부분에 array를 넣어주는 것과 그냥 하나만 넣어주는 것 차이가 어떤지 해보자.
        // array를 넣어주면 error, 최초의 vc를 넣어주는 것
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pagesControl.currentPageIndicatorTintColor = .systemYellow
        pagesControl.pageIndicatorTintColor = .gray
        pagesControl.numberOfPages = pages.count
        pagesControl.currentPage = initialPage
        
        view.addSubview(pagesControl)
        pagesControl.translatesAutoresizingMaskIntoConstraints = false
        pagesControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        pagesControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        pagesControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}

extension LocalSignInViewViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }

    }

}

extension LocalSignInViewViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pagesControl.currentPage = currentIndex
        
    }
    
}
