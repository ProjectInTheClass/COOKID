//
//  OnboardingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import RxSwift
import RxCocoa

class OnboardingViewModel: ViewModelType {
    
    let userService: UserService
    let mealService: MealService
    let shoppingService: ShoppingService
    
    struct Input {
        let nickname: BehaviorRelay<String>
        let monthlyGoal: BehaviorRelay<Int>
        let usertype: BehaviorRelay<UserType>
        let determination: BehaviorRelay<String>
    }
    
    struct Output {
        let userInformation: Observable<User>
    }
    
    var input: Input
    
    var output: Output
    
    init(userService: UserService, mealService: MealService, shoppingService: ShoppingService) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
        
        let nickname = BehaviorRelay<String>(value: "기본")
        let monthlyGoal = BehaviorRelay<Int>(value: 0)
        let usertype = BehaviorRelay<UserType>(value: .preferDineIn)
        let determination = BehaviorRelay<String>(value: "화이팅!")
        
        let userInformation = Observable.combineLatest(nickname, determination, usertype, monthlyGoal, resultSelector: { name, deter, usertype, monthlyGoal -> User in
            return User(id: "", nickname: name, determination: deter, priceGoal: monthlyGoal, userType: usertype, dineInCount: 0, cookidsCount: 0)
        })
        
        self.input = Input(nickname: nickname, monthlyGoal: monthlyGoal, usertype: usertype, determination: determination)
        self.output = Output(userInformation: userInformation)
    }
    
}
