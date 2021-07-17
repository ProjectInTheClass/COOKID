//
//  MyExpenseViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MyExpenseViewModel: ViewModelType {
    
    let mealService: MealService
    let userService: UserService
    let shoppingService: ShoppingService
    
    struct Input {
        
    }
    
    struct Output {
        let averagePrice: Driver<String>
        let updateShoppingList: Driver<([Meal], [GroceryShopping])>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, shoppingService: ShoppingService) {
        self.mealService = mealService
        self.userService = userService
        self.shoppingService = shoppingService
        
        // user 넣어줘야 함
        
        userService.loadUserInfo { user in
            mealService.fetchMeals(user: user) { _ in }
            shoppingService.fetchGroceries(user: user) { _ in }
        }
        
        
        let meals = mealService.mealList()
        let shoppings = shoppingService.shoppingList()

        let averagePrice = Observable.combineLatest(shoppings.map(shoppingService.fetchShoppingTotalSpend), meals.map(mealService.fetchEatOutSpend)) { shoppingPrice, meealPrice -> Double in
            let day = Calendar.current.ordinality(of: .day, in: .month, for: Date()) ?? 1
            return Double(shoppingPrice + meealPrice) / Double(day)
        }
        .map({ price -> String in
            return "현재까지 평균 지출은 '\(String(format: "%.0f", price))원' 입니다."
        })
        .asDriver(onErrorJustReturn: "지출이 없습니다.")
        
        let updateShoppingList = Observable.combineLatest(meals, shoppings, resultSelector: { meals, shoppings -> ([Meal], [GroceryShopping]) in
            return (meals, shoppings)
        })
        .asDriver(onErrorJustReturn: ([], []))
        
        
        self.input = Input()
        self.output = Output(averagePrice: averagePrice, updateShoppingList: updateShoppingList)
    }
}
