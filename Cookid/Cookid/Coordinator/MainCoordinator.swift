//
//  MainCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit
import FirebaseAuth

protocol CoordinatorType {
    var childCoordinator: [CoordinatorType] { get set }
    var navigationController: UINavigationController? { get set }
    
    @discardableResult
    func start() -> UIViewController
}

class MainCoordinator: CoordinatorType {
    
    var childCoordinator = [CoordinatorType]()
    var navigationController: UINavigationController? = nil
    
    // MARK: - START
    
    func start() -> UIViewController {
        if Auth.auth().currentUser != nil {
            let homeCoordinator = HomeCoordinator(parentCoordinator: self)
            childCoordinator.append(homeCoordinator)
            return homeCoordinator.start()
        } else {
            let onBoardingCoordinator = OnboardingCoordinator(parentCoordinator: self)
            childCoordinator.append(onBoardingCoordinator)
            return onBoardingCoordinator.start()
        }
    }
    
}