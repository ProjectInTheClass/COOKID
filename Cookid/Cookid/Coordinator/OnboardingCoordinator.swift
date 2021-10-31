//
//  OnboardingCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit

class OnboardingCoordinator: CoordinatorType {
    
    var parentCoordinator : CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var navigationController: UINavigationController?
    
    init(parentCoordinator : CoordinatorType) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        let mealService = MealService()
        let shoppingService = ShoppingService()
        let serviceProvider = ServiceProvider()
        let pageVC = OnboardingPageViewViewController(coordinator: self, serviceProvider: serviceProvider, mealService: mealService, shoppingService: shoppingService)
        return pageVC
    }
}
