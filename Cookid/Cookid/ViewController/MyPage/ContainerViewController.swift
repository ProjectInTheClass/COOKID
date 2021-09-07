//
//  ContainerViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/07.
//

import UIKit

class ContainerViewController: UIViewController {
    
    weak var contentsDelegate: ContentsViewControllerDelegate?
    var myViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.myViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let beforeIndex = viewControllerIndex - 1
        if(beforeIndex < 0) {
            return nil
        }
        return self.myViewControllers[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.myViewControllers.firstIndex(of: viewController) else {
            return nil
        }
     
        let afterIndex = viewControllerIndex + 1
        if(afterIndex >= self.myViewControllers.count) {
            return nil
        }
        return self.myViewControllers[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let first = pageViewController.viewControllers?.first, completed {
            if let currentViewControllerIndex = self.myViewControllers.firstIndex(of: first) {
                self.currentIndex = currentViewControllerIndex
                self.contentsDelegate?.scrolledContentsViewController(currentIndex: currentViewControllerIndex)
            }
        }
    }
}
