//
//  OnboardingCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit

class OnboardingCoordinator: CoordinatorType {
    
    var parentCoordinator : MainCoordinator?
    var childCoordinator: [CoordinatorType] = []
    var navigationController: UINavigationController?
    
    init(parentCoordinator : MainCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        
        let mealService = MealService()
        let shoppingService = ShoppingService()
        let userService = UserService()
        let pageVC = OnboardingPageViewViewController(coordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService)
        return pageVC
    }
}
