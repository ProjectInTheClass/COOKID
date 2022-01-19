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
        let postService = safeResolver.resolve(PostServiceType.self)!
        
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
        
        container.register(MainViewModel.self, name: nil) { resolver in
            return MainViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService)
        }
    
        container.register(PostMainViewController.self, name: nil) { resolver in
            return PostViewModel(userService: userService, postService: postService)
        }
        
        container.register(MyPageViewModel.self, name: nil) { resolver in
            return MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService)
        }
        
        container.register(UITabBarController.self, name: nil) { resolver in
            
            // 3가지 뷰컨 선언, TabVC에 넣기
            var mainVC = MainViewController.instantiate(storyboardID: "Main")
            mainVC.bind(viewModel: safeResolver.resolve(MainViewModel.self)!)
            
            var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
            postMainVC.bind(viewModel: safeResolver.resolve(PostViewModel.self)!)
            
            var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
            myPageVC.bind(viewModel: safeResolver.resolve(MyPageViewModel.self)!)
            
            // tabbar
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([mainVC, postMainVC, myPageVC], animated: false)
            tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
            tabBarController.tabBar.items?[2].title = "마이페이지"
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            return tabBarController
        }
    }
}
