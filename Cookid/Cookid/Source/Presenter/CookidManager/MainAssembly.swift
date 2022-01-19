//
//  MainAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

class MainAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        
        let userService = safeResolver.resolve(UserServiceType.self)!
        let mealService = safeResolver.resolve(MealServiceType.self)!
        let shoppingService = safeResolver.resolve(ShoppingServiceType.self)!
        
        container.register(NetworkAPIType.self, name: nil) { resolver in
            return PhotoAPI()
        }
        
        container.register(AddMealReactor.self, name: "new") { resolver in
            let photoService = safeResolver.resolve(PhotoServiceType.self)!
            return AddMealReactor(mode: .new, photoService: photoService, userService: userService, mealService: mealService)
        }
        
        container.register(PhotoSelectViewController.self, name: nil) { resolver in
            let reactor = resolver.resolve(AddMealReactor.self)!
            let vc = PhotoSelectViewController()
            vc.reactor = reactor
            return vc
        }
        
        container.register(UITabBarController.self, name: nil) { resolver in
            
            // 3가지 뷰컨 선언, TabVC에 넣기
            
            var mainVC = MainViewController.instantiate(storyboardID: "Main")
            mainVC.bind(viewModel: MainViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService))
            
            var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
            postMainVC.bind(viewModel: PostViewModel(serviceProvider: serviceProvider))
            postMainVC.coordinator = self
            
            var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
            myPageVC.coordinator = self
            myPageVC.bind(viewModel: MyPageViewModel(serviceProvider: serviceProvider))
            
            
            // tabbar
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([mainVC, postMainVC, myPageVC], animated: false)
            tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
            tabBarController.tabBar.items?[2].title = "마이페이지"
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            
        }
    }
}
