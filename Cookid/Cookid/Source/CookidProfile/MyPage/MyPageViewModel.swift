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
        let userInfo = serviceProvider.userService.currentUser
        let meals = serviceProvider.mealService.mealList
        let shoppings = serviceProvider.shoppingService.shoppingList
        
        _ = userInfo
            .flatMap({ serviceProvider.postService.fetchMyPosts(user: $0) })
        
        let dineInCount =
        meals.map { $0.filter { $0.mealType == .dineIn }.count }
        
        let cookidsCount =
        Observable.combineLatest(meals, shoppings) { $0.count + $1.count }
        
        let postCount =
        serviceProvider.postService.myTotalPosts.map { $0.count }
        
        let myPosts =
        serviceProvider.postService.myTotalPosts
        
        self.input = Input()
        self.output = Output(userInfo: userInfo, meals: meals, dineInCount: dineInCount, cookidsCount: cookidsCount, postCount: postCount, myPosts: myPosts)
        super.init(serviceProvider: serviceProvider)
    }
}
