//
//  Extension.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true, completion: ((Bool)->Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
}

extension UIView {
    
    func makeShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
    }
    
}
