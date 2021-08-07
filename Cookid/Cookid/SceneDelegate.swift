//
//  SceneDelegate.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let mealRepo = MealRepository()
        let userRepo = UserRepository()
        let groceryRepo = GroceryRepository()
        let mealService = MealService(mealRepository: mealRepo, userRepository: userRepo, groceryRepository: groceryRepo)
        let userService = UserService(userRepository: userRepo)
        let shoppingService = ShoppingService(groceryRepository: groceryRepo)
        
        if Auth.auth().currentUser != nil {
            var mainVC = MainViewController.instantiate(storyboardID: "Main")
            mainVC.bind(viewModel: MainViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
            let mainNVC = UINavigationController(rootViewController: mainVC)
            mainVC.navigationController?.navigationBar.prefersLargeTitles = true

            var myMealVC = MyMealViewController.instantiate(storyboardID: "MyMealTap")
            myMealVC.bind(viewModel: MyMealViewModel(mealService: mealService, userService: userService))
            let myMealNVC = UINavigationController(rootViewController: myMealVC)
            myMealVC.navigationController?.navigationBar.prefersLargeTitles = true

            var myExpenseVC = MyExpenseViewController.instantiate(storyboardID: "MyExpenseTap")
            myExpenseVC.bind(viewModel: MyExpenseViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
            let myExpenseNVC = UINavigationController(rootViewController: myExpenseVC)
            myExpenseVC.navigationController?.navigationBar.prefersLargeTitles = true

            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([mainNVC, myMealNVC, myExpenseNVC], animated: false)
            tabBarController.tabBar.tintColor = .black
            window?.rootViewController = tabBarController
        } else {
            let pageVC = OnboardingPageViewViewController(userService: userService, mealService: mealService)
            window?.rootViewController = pageVC
        }
     
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

