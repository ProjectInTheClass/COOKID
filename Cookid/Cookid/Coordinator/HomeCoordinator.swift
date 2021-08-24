//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit

class HomeCoordinator: CoordinatorType {
    
    var parentCoordinator : CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    
    var navigationController: UINavigationController? = nil
    
    var mainNVC: UINavigationController?

    init(parentCoordinator : CoordinatorType) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        let mealRepo = MealRepository()
        let userRepo = UserRepository()
        let groceryRepo = GroceryRepository()
        let mealService = MealService(mealRepository: mealRepo, userRepository: userRepo, groceryRepository: groceryRepo)
        let userService = UserService(userRepository: userRepo)
        let shoppingService = ShoppingService(groceryRepository: groceryRepo)
        
        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        mainVC.coordinator = self
        mainNVC = UINavigationController(rootViewController: mainVC)
        
        mainVC.navigationController?.navigationBar.prefersLargeTitles = true
        mainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        
        var myMealVC = MyMealViewController.instantiate(storyboardID: "MyMealTap")
        myMealVC.bind(viewModel: MyMealViewModel(mealService: mealService, userService: userService))
        let myMealNVC = UINavigationController(rootViewController: myMealVC)
        myMealVC.navigationController?.navigationBar.prefersLargeTitles = true
        
        var myExpenseVC = MyExpenseViewController.instantiate(storyboardID: "MyExpenseTap")
        myExpenseVC.bind(viewModel: MyExpenseViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        let myExpenseNVC = UINavigationController(rootViewController: myExpenseVC)
        myExpenseVC.navigationController?.navigationBar.prefersLargeTitles = true
        myExpenseVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC!, myMealNVC, myExpenseNVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        return tabBarController
    }
    
    func navigateSelectCalendarVC(viewModel: MainViewModel) {
        var vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
        vc.bind(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        mainNVC?.present(vc, animated: true, completion: nil)
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
        mainNVC?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(viewModel: MainViewModel, shopping: GroceryShopping?) {
        let vc = InputDataShoppingViewController(service: viewModel.shoppingService)
        vc.shopping = shopping
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selectBtn(btnState: .saveBtnOn)
        mainNVC?.present(vc, animated: true, completion: nil)
    }
    
    func navigateRankingVC(viewModel: MainViewModel) {
        let rankingViewModel = RankingViewModel(userService: viewModel.userService)
        
        var vc = RankingMainViewController()
        vc.bind(viewModel: rankingViewModel)
        vc.modalPresentationStyle = .automatic
        mainNVC?.pushViewController(vc, animated: true)
    }
    
    func navigateUserInfoVC(viewModel: MainViewModel) {
        let userUpdateViewModel = UserInfoUpdateViewModel(userService: viewModel.userService)
        var userInfoVC = UserInformationViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: userUpdateViewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
       
        mainNVC?.present(userInfoVC, animated: true, completion: nil)
    }
    
}
