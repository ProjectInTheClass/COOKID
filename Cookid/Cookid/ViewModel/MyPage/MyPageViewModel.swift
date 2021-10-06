//
//  MyPageViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType {
    
    let userService: UserService
    let mealService: MealService
    let shoppingService: ShoppingService
    let postService: PostService
    
    struct Input {
        
    }
    
    struct Output {
        let userInfo: Observable<User>
        let meals: Observable<[Meal]>
        let dineInCount: Observable<Int>
        let cookidsCount: Observable<Int>
        let postCount: Observable<Int>
        let myPosts: Observable<[Post]>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService, mealService: MealService, shoppingService: ShoppingService, postService: PostService) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
        self.postService = postService
        
        let userInfo = userService.user()
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()
        
        let dineInCount = meals.map { meals -> Int in
            return meals.filter { $0.mealType == .dineIn }.count
        }
        
        let cookidsCount = Observable.combineLatest(meals, shoppings) { meals, shoppings -> Int in
            return meals.count + shoppings.count
        }
        
        let postCount = postService.postsCount
        
        let myPosts = userService.user().flatMap(postService.myPosts(user:))
        
        self.input = Input()
        self.output = Output(userInfo: userInfo, meals: meals, dineInCount: dineInCount, cookidsCount: cookidsCount, postCount: postCount, myPosts: myPosts)
    }
}
