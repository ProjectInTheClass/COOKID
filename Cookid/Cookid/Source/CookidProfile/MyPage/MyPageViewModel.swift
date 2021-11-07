//
//  MyPageViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class MyPageViewModel: BaseViewModel, ViewModelType, HasDisposeBag {
   
    struct Input {
        let userImageSelect = PublishRelay<UIImage>()
    }
    
    struct Output {
        let userInfo = BehaviorRelay<User>(value: DummyData.shared.singleUser)
        let meals = BehaviorRelay<[Meal]>(value: [])
        let dineInCount = BehaviorRelay<Int>(value: 0)
        let cookidsCount = BehaviorRelay<Int>(value: 0)
        let myPostCount = BehaviorRelay<Int>(value: 0)
        let myPosts = BehaviorRelay<[Post]>(value: [])
    }
    
    var input: Input
    var output: Output
    
    override init(serviceProvider: ServiceProviderType) {
        self.input = Input()
        self.output = Output()
        super.init(serviceProvider: serviceProvider)
        
        let currentUser = serviceProvider.userService.currentUser
        let meals = serviceProvider.mealService.mealList
        let shoppings = serviceProvider.shoppingService.shoppingList
        let myPosts = serviceProvider.postService.myTotalPosts
        
        meals
            .bind(to: output.meals)
            .disposed(by: disposeBag)
        
        meals
            .map { $0.filter { $0.mealType == .dineIn }.count }
            .bind(to: output.dineInCount)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(meals, shoppings) { $0.count + $1.count }
            .bind(to: output.cookidsCount)
            .disposed(by: disposeBag)
        
        myPosts
            .map { $0.count }
            .bind(to: output.myPostCount)
            .disposed(by: disposeBag)
        
        myPosts
            .bind(to: output.myPosts)
            .disposed(by: disposeBag)
        
        currentUser
            .bind(to: output.userInfo)
            .disposed(by: disposeBag)
        
        input.userImageSelect
            .withLatestFrom(currentUser,
                            resultSelector: { ($0, $1) })
            .bind(onNext: { (image, user) in
                serviceProvider.userService.updateUserImage(user: user, profileImage: image, completion: { _ in })
            })
            .disposed(by: disposeBag)
    }
    
    func fetchInitialData(user: User) {
        serviceProvider.postService.fetchMyPosts(user: user)
    }
    
}
