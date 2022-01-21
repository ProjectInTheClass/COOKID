//
//  MyPageAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/19.
//

import Foundation
import Swinject

class MyPageAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        let userService = safeResolver.resolve(UserServiceType.self)!
        let mealService = safeResolver.resolve(MealServiceType.self)!
        let shoppingService = safeResolver.resolve(ShoppingServiceType.self)!
        let postService = safeResolver.resolve(PostServiceType.self)!
        
        container.register(MyPostReactor.self) { resolver in
            return MyPostReactor(userService: userService, postService: postService)
        }
        
        container.register(MyBookmarkReactor.self) { resolver in
            return MyBookmarkReactor(userService: userService, postService: postService, shoppingService: shoppingService, mealService: mealService)
        }
        
        container.register(MyRecipeReactor.self) { resolver in
            return MyRecipeReactor(userService: userService, postService: postService)
        }
    }
}
