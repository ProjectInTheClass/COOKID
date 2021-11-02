//
//  MyPageViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: BaseViewModel, ViewModelType {
   
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
    
    override init(serviceProvider: ServiceProviderType) {
        let userInfo = userService.user()
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()
        
        _ = userInfo.flatMap({ postService.fetchMyPosts(user: $0) })
        
        let dineInCount = meals.map { meals -> Int in
            return meals.filter { $0.mealType == .dineIn }.count
        }
        
        let cookidsCount = Observable.combineLatest(meals, shoppings) { meals, shoppings -> Int in
            return meals.count + shoppings.count
        }
        
        let postCount = postService.myTotalPosts.map { $0.count }
        
        let myPosts = postService.myTotalPosts
        
        self.input = Input()
        self.output = Output(userInfo: userInfo, meals: meals, dineInCount: dineInCount, cookidsCount: cookidsCount, postCount: postCount, myPosts: myPosts)
        super.init(serviceProvider: serviceProvider)
    }
}
