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
    
}
