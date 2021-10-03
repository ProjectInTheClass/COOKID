//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit

class HomeCoordinator: CoordinatorType {
    
    var parentCoordinator : CoordinatorType
    var childCoordinator: [CoordinatorType] = []
    
    var navigationController: UINavigationController?

    init(parentCoordinator : CoordinatorType) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        let firestorePostRepo = FirestorePostRepo()
        let mealService = MealService()
        let userService = UserService()
        let shoppingService = ShoppingService()
        let postService = PostService(firestoreRepo: firestorePostRepo)
        let commentService = CommentService()
        
        let mainCoordinator = MainCoordinator(parentCoordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService)
        let mainNVC = mainCoordinator.start()
        childCoordinator.append(mainCoordinator)
        
        let postCoordinator = PostCoordinator(parentCoordinator: self, userService: userService, commentService: commentService, postService: postService, mealService: mealService, shoppingService: shoppingService)
        let postNVC = postCoordinator.start()
        childCoordinator.append(postCoordinator)
        
        let myPageCoordinator = MyPageCoordinator(parentCoordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService)
        let myPageNVC = myPageCoordinator.start()
        childCoordinator.append(myPageCoordinator)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC, postNVC, myPageNVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.tabBar.items?[2].title = "내 정보"
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        return tabBarController
    }
    
}
