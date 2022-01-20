//
//  PostAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/19.
//

import Foundation
import Swinject

class PostAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        let userService = safeResolver.resolve(UserServiceType.self)!
        let mealService = safeResolver.resolve(MealServiceType.self)!
        let shoppingService = safeResolver.resolve(ShoppingServiceType.self)!
        let postService = safeResolver.resolve(PostServiceType.self)!
        
        container.register(AddPostReactor.self, name: "new") { resolver in
            return AddPostReactor(mode: .new, userService: userService, postService: postService)
        }
    }
}
