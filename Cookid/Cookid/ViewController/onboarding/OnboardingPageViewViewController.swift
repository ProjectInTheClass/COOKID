//
//  OnboardingPageViewViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class OnboardingPageViewViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    
    let pagesControl = UIPageControl()
    
    let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        setupPageControl()
        
    }
    

    private func setupPages() {
        
        self.dataSource = self
        self.delegate = self
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let viewModel = OnboardingViewModel()
        
        let firstPage = sb.instantiateViewController(withIdentifier: "FirstPageViewController") as! FirstPageViewController
        
        firstPage.completionHandler = { [weak self] in
            print("tapped")
            self?.goToNextPage()
        }
        
        firstPage.viewModel = viewModel
        
        let secondPage = sb.instantiateViewController(withIdentifier: "SecondPageViewController") as! SecondPageViewController
        let thirdPage = sb.instantiateViewController(withIdentifier: "ThirdPageViewController") as! ThirdPageViewController
        let fourthPage = sb.instantiateViewController(withIdentifier: "FourthPageViewController") as! FourthPageViewController
        
        fourthPage.viewModel = viewModel
        
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

extension OnboardingPageViewViewController: UIPageViewControllerDataSource {
    
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

extension OnboardingPageViewViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        pagesControl.currentPage = currentIndex
        
    }
    
}
