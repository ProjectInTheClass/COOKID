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
        let firebaseStorageRepo = FirebaseStorageRepo()
        let firestoreUserRepo = FirestoreUserRepo()
        let firestoreCommentRepo = FirestoreCommentRepo()
        let imageRepo = ImageRepo()
        let realmMealRepo = RealmMealRepo()
        let mealService = MealService(imageRepo: imageRepo, realmMealRepo: realmMealRepo)
        let userService = UserService(firestoreUserRepo: firestoreUserRepo)
        let shoppingService = ShoppingService()
        let commentService = CommentService(firestoreCommentRepo: firestoreCommentRepo, firestoreUserRepo: firestoreUserRepo)
        let postService = PostService(firestoreRepo: firestorePostRepo, firebaseStorageRepo: firebaseStorageRepo, firestoreUserRepo: firestoreUserRepo, commentService: commentService)
        let mainCoordinator = MainCoordinator(parentCoordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService)
        let mainNVC = mainCoordinator.start()
        childCoordinator.append(mainCoordinator)
        
        let postCoordinator = PostCoordinator(parentCoordinator: self, userService: userService, commentService: commentService, postService: postService, mealService: mealService, shoppingService: shoppingService)
        let postNVC = postCoordinator.start()
        childCoordinator.append(postCoordinator)
        
        let myPageCoordinator = MyPageCoordinator(parentCoordinator: self, userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService, commentService: commentService)
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
