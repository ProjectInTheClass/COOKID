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
        let commentService = safeResolver.resolve(CommentServiceType.self)!
        
        container.register(PostViewModel.self, name: nil) { resolver in
            return PostViewModel(userService: userService, postService: postService, shoppingService: shoppingService, mealService: mealService)
        }
        
        container.register(AddPostReactor.self, name: nil) { (_, mode: PostEditViewMode) in
            return AddPostReactor(mode: mode, userService: userService, postService: postService)
        }
        
        container.register(RankingViewModel.self, name: nil) { resolver in
            return RankingViewModel(userService: userService)
        }
        
        container.register(CommentViewModel.self) { (_, post: Post) in
            return CommentViewModel(post: post, userService: userService, commentService: commentService)
        }
    }
}
