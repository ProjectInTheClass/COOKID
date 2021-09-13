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
    
    struct Input {
        
    }
    
    struct Output {
        let userInfo: Observable<User>
        let meals: Observable<[Meal]>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService, mealService: MealService, shoppingService: ShoppingService) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
        
        let userInfo = userService.user()
        let meals = mealService.mealList()
        
        self.input = Input()
        self.output = Output(userInfo: userInfo, meals: meals)
    }
}
