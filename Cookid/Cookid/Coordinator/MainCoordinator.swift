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
        mainVC.navigationController?.navigationBar.prefersLargeTitles = true
        mainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        mainVC.navigationController?.navigationBar.barTintColor = .systemBackground
        return navigationController!
    }
    
    func navigateSelectCalendarVC(viewModel: MainViewModel) {
        var vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
        vc.bind(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddMealVC(viewModel: MainViewModel, meal: Meal?) {
        let mealID = meal != nil ? meal?.id : UUID().uuidString
        let addMealViewModel = AddMealViewModel(mealService: viewModel.mealService, userService: viewModel.userService, mealID: mealID)
        var vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.meal = meal
        vc.bind(viewModel: addMealViewModel)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(viewModel: MainViewModel, shopping: GroceryShopping?) {
        let shoppingID = shopping != nil ? shopping?.id : UUID().uuidString
        let addShoppingViewModel = AddShoppingViewModel(shoppingService: viewModel.shoppingService, userService: viewModel.userService, shoppingID: shoppingID)
        var vc = AddShoppingViewController()
        vc.shopping = shopping
        vc.bind(viewModel: addShoppingViewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateUserInfoVC(viewModel: MyPageViewModel) {
        let userUpdateViewModel = UserInfoUpdateViewModel(userService: viewModel.userService)
        var userInfoVC = UserInformationViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: userUpdateViewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(userInfoVC, animated: true, completion: nil)
    }
}
