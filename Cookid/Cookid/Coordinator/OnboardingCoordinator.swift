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
        
        let mealRepo = MealRepository()
        let userRepo = UserRepository()
        let groceryRepo = GroceryRepository()
        
        let mealService = MealService(mealRepository: mealRepo, userRepository: userRepo, groceryRepository: groceryRepo)
        let shoppingService = ShoppingService(groceryRepository: groceryRepo)
        let userService = UserService(userRepository: userRepo)
        let pageVC = OnboardingPageViewViewController(coordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService)
        return pageVC
    }
}
