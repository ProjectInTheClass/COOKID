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


extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
}


extension String {
    func StringTodate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.date(from: self)
    }
}