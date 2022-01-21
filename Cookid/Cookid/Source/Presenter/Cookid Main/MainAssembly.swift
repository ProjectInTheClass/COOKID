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
        
        container.register(AddMealReactor.self) { (_, mode: MealEditMode) in
            let photoService = safeResolver.resolve(PhotoServiceType.self)!
            return AddMealReactor(mode: mode, photoService: photoService, userService: userService, mealService: mealService)
        }
        
        container.register(PhotoSelectViewController.self, name: nil) { _ in
            let reactor = safeResolver.resolve(AddMealReactor.self)!
            let vc = PhotoSelectViewController()
            vc.reactor = reactor
            return vc
        }
        
        // AddToday
        container.register(AddTodayReactor.self, name: nil) { resolver in
            return AddTodayReactor(userService: userService, mealService: mealService)
        }
        
        container.register(AddTodayMealViewController.self, name: nil) { _ in
            let reactor = safeResolver.resolve(AddTodayReactor.self)!
            let vc = AddTodayMealViewController.instantiate(storyboardID: "Main")
            vc.reactor = reactor
            return vc
        }
        
        // AddShopping
        container.register(AddShoppingReactor.self, name: nil) { (_, mode: ShoppingEditMode) in
            return AddShoppingReactor(mode: mode, userService: userService, shoppingService: shoppingService)
        }
        
        container.register(AddShoppingViewController.self, name: nil) { (_, mode: ShoppingEditMode) in
            let reactor = safeResolver.resolve(AddShoppingReactor.self, argument: mode)!
            let vc = AddShoppingViewController()
            vc.reactor = reactor
            return vc
        }
        
        container.register(MyPageViewModel.self, name: nil) { _ in
            return MyPageViewModel(userService: userService, mealService: mealService, shoppingService: shoppingService, postService: postService)
        }
    }
}
