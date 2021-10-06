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
    let postService: PostService
    
    init(parentCoordinator : CoordinatorType, userService: UserService, mealService: MealService, shoppingService: ShoppingService, postService: PostService) {
        self.parentCoordinator = parentCoordinator
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
        self.postService = postService
        
    }
    
    func start() -> UIViewController {
        var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
        myPageVC.coordinator = self
        myPageVC.bind(viewModel: MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService))
        navigationController = UINavigationController(rootViewController: myPageVC)
        myPageVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        myPageVC.navigationController?.navigationBar.barTintColor = .systemBackground
        return navigationController!
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
