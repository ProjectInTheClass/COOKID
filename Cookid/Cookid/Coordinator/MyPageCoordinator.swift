//
//  MyPageCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class MyPageCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    
    let userService: UserService
    let mealService: MealService
    let shoppingService: ShoppingService
    
    init(parentCoordinator : CoordinatorType, userService: UserService, mealService: MealService, shoppingService: ShoppingService) {
        self.parentCoordinator = parentCoordinator
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
    }
    
    func start() -> UIViewController {
        var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
        myPageVC.coordinator = self
        myPageVC.bind(viewModel: MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService))
        navigationController = UINavigationController(rootViewController: myPageVC)
        myPageVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        myPageVC.navigationController?.navigationBar.barTintColor = .systemBackground
        return navigationController!
    }
 
}
