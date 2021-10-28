//
//  MainCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class MainCoordinator: CoordinatorType {
    
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
        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        mainVC.coordinator = self
        navigationController = UINavigationController(rootViewController: mainVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateSelectCalendarVC(viewModel: MainViewModel) {
        var vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
        vc.bind(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddMealVC(meal: Meal?) {
        let vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = AddMealReactor(mealService: mealService, meal: meal)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(shopping: GroceryShopping?) {
        let shoppingID = shopping != nil ? shopping?.id : UUID().uuidString
        let addShoppingViewModel = AddShoppingViewModel(shoppingService: shoppingService, userService: userService, shoppingID: shoppingID)
        var vc = AddShoppingViewController()
        vc.shopping = shopping
        vc.bind(viewModel: addShoppingViewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddTodayMeal() {
        let vc = AddTodayMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = AddTodayReactor(mealService: mealService, userService: userService)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
