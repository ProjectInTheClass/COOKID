//
//  HomeAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        let userService = safeResolver.resolve(UserServiceType.self)!
        let mealService = safeResolver.resolve(MealServiceType.self)!
        let shoppingService = safeResolver.resolve(ShoppingServiceType.self)!
        let postService = safeResolver.resolve(PostServiceType.self)!
        
        // Main
        container.register(MainViewModel.self, name: nil) { _ in
            return MainViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService)
        }
        
        container.register(MainViewController.self, name: nil) { _ in
            var vc = MainViewController.instantiate(storyboardID: "Main")
            vc.bind(viewModel: safeResolver.resolve(MainViewModel.self)!)
            return vc
        }
        
        // Post
        container.register(PostViewModel.self, name: nil) { _ in
            return PostViewModel(userService: userService, postService: postService, shoppingService: shoppingService, mealService: mealService)
        }
        
        container.register(PostMainViewController.self, name: nil) { _ in
            var vc = PostMainViewController.instantiate(storyboardID: "Post")
            vc.bind(viewModel: safeResolver.resolve(PostViewModel.self)!)
            return vc
        }
        
        // Profile
        container.register(MyPageViewModel.self, name: nil) { _ in
            return MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService)
        }
        
        container.register(MyPageViewController.self, name: nil) { _ in
            var vc = MyPageViewController.instantiate(storyboardID: "UserInfo")
            vc.bind(viewModel: safeResolver.resolve(MyPageViewModel.self)!)
            return vc
        }
        
    }
}
