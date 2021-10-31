//
//  ServiceProvider.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var userService: UserServiceType { get }
    var postService: PostServiceType { get }
    var commentService: CommentServiceType { get }
    var mealService: MealServiceType { get }
    var shoppingService: ShoppingServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    let repoProvider = RepositoryProvider()
    lazy var mealService: MealServiceType = MealService(serviceProvider: self, repoProvider: repoProvider)
    lazy var shoppingService: ShoppingServiceType = ShoppingService(serviceProvider: self, repoProvider: repoProvider)
    lazy var userService: UserServiceType = UserService(serviceProvider: self, repoProvider: repoProvider)
    lazy var postService: PostServiceType = PostService(serviceProvider: self, repoProvider: repoProvider)
    lazy var commentService: CommentServiceType = CommentService(serviceProvider: self, repoProvider: repoProvider)
}
