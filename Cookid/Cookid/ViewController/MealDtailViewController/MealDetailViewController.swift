////
////  MealDetailViewController.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/12.
////
//
import UIKit
import SwiftUI

class MealDetailViewController : UIHostingController<MealDetailView> {
    @Namespace static var namespace
    
    override init(rootView: MealDetailView) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
//        let mealDetailVC = UIHostingController(rootView: MealDetailView())
//
//        self.addChild(mealDetailVC)
//        self.view.addSubview(mealDetailVC.view)
//        mealDetailVC.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            mealDetailVC.view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
//            mealDetailVC.view.heightAnchor.constraint(equalTo: self.view.heightAnchor)
//        ])
    
}
