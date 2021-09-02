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
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: PublishRelay<String>
        let monthlyGoal: PublishRelay<Int>
        let usertype: PublishRelay<UserType>
        let determination: PublishRelay<String>
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
        
        let nickname = PublishRelay<String>()
        let monthlyGoal = PublishRelay<Int>()
        let usertype = PublishRelay<UserType>()
        let determination = PublishRelay<String>()
        
        let userInformation = Observable.combineLatest(nickname, determination, usertype, monthlyGoal, resultSelector: { name, deter, usertype, monthlyGoal -> User in
            return User(userID: "", nickname: name, determination: deter, priceGoal: monthlyGoal, userType: usertype)
        })
        
        self.input = Input(nickname: nickname, monthlyGoal: monthlyGoal, usertype: usertype, determination: determination)
        self.output = Output(userInformation: userInformation)
    }
    
}
