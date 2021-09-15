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
    
    var navigationController: UINavigationController?
    
    var mainNVC: UINavigationController?
    var postMainNVC: UINavigationController?

    init(parentCoordinator : CoordinatorType) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        let mealService = MealService()
        let userService = UserService()
        let shoppingService = ShoppingService()
        let postService = PostService()
        let commentService = CommentService()
        
        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        mainVC.coordinator = self
        mainNVC = UINavigationController(rootViewController: mainVC)
        mainVC.navigationController?.navigationBar.prefersLargeTitles = true
        mainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        mainVC.navigationController?.navigationBar.barTintColor = .systemBackground
        
        var myMealVC = MyMealViewController.instantiate(storyboardID: "MyMealTap")
        myMealVC.bind(viewModel: MyMealViewModel(mealService: mealService, userService: userService))
        myMealVC.coordinator = self
        let myMealNVC = UINavigationController(rootViewController: myMealVC)
        myMealVC.navigationController?.navigationBar.prefersLargeTitles = true
        myMealVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        myMealVC.navigationController?.navigationBar.barTintColor = .systemBackground
        
        var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
        postMainVC.bind(viewModel: PostViewModel(postService: postService, userService: userService, commentService: commentService))
        postMainVC.coordinator = self
        postMainNVC = UINavigationController(rootViewController: postMainVC)
        postMainVC.navigationController?.navigationBar.prefersLargeTitles = true
        postMainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        postMainVC.navigationController?.navigationBar.barTintColor = .systemBackground
        
        var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
        myPageVC.coordinator = self
        myPageVC.bind(viewModel: MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService))
        
        let myPageNVC = UINavigationController(rootViewController: myPageVC)
        myPageVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        myPageVC.navigationController?.navigationBar.barTintColor = .systemBackground

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC!, myMealNVC, postMainNVC!, myPageNVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.tabBar.items?[3].title = "내 정보"
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
        let shoppingID = shopping != nil ? shopping?.id : UUID().uuidString
        let addShoppingViewModel = AddShoppingViewModel(shoppingService: viewModel.shoppingService, userService: viewModel.userService, shoppingID: shoppingID)
        var vc = AddShoppingViewController()
        vc.shopping = shopping
        vc.bind(viewModel: addShoppingViewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        mainNVC?.present(vc, animated: true, completion: nil)
    }
    
    func navigateRankingVC(viewModel: PostViewModel) {
        let rankingViewModel = RankingViewModel(userService: viewModel.userService)
        
        var vc = RankingMainViewController()
        vc.bind(viewModel: rankingViewModel)
        vc.modalPresentationStyle = .automatic
        postMainNVC?.pushViewController(vc, animated: true)
    }
    
    func navigateAddPostVC(viewModel: PostViewModel) {
        var vc = AddPostViewController.instantiate(storyboardID: "Post")
        // 받아와서 올리기
    }
    
    func navigateUserInfoVC(viewModel: MyPageViewModel) {
        let userUpdateViewModel = UserInfoUpdateViewModel(userService: viewModel.userService)
        var userInfoVC = UserInformationViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: userUpdateViewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
       
        mainNVC?.present(userInfoVC, animated: true, completion: nil)
    }
    
    func navigateSignInVC(viewModel: PostViewModel) {
        var signInVC = SignInViewController.instantiate(storyboardID: "UserInfo")
        signInVC.bind(viewModel: viewModel)
        signInVC.modalPresentationStyle = .overFullScreen
        postMainNVC?.present(signInVC, animated: true)
    }
    
}
