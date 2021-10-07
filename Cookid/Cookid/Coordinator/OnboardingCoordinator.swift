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
        let firestoreUserRepo = FirestoreUserRepo()
        let userService = UserService(firestoreUserRepo: firestoreUserRepo)
        let pageVC = OnboardingPageViewViewController(coordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService)
        return pageVC
    }
}
