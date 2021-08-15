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
    
    struct MySection {
        var header : String
        var items : [Any]
    }

    struct Input {
        let selectedDates : BehaviorSubject<[Date]>
    }
    
    struct Output {
        let averagePrice: Driver<String>
        let updateData: Driver<([Meal], [Meal], [GroceryShopping])>
        let updateDataBySelectedDates: Driver<([Meal], [Meal], [GroceryShopping])>
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>
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
        
        let selectedDates = BehaviorSubject<[Date]>(value: [])
        

        let averagePrice = Observable.combineLatest(shoppings.map(shoppingService.fetchShoppingTotalSpend), meals.map(mealService.fetchEatOutSpend)) { shoppingPrice, mealPrice -> Double in
            let day = Calendar.current.ordinality(of: .day, in: .month, for: Date()) ?? 1
            return Double(shoppingPrice + mealPrice) / Double(day)
        }
        .map({ price -> String in
            return "현재까지 하루 평균 지출은 '\(String(format: "%.0f", price))원' 입니다."
        })
        .asDriver(onErrorJustReturn: "지출이 없습니다.")
        
        let updateData = Observable.combineLatest(meals, shoppings, resultSelector: { meals, shoppings -> ([Meal], [Meal], [GroceryShopping]) in
            let dineOutMeals = meals.filter{ $0.mealType == .dineOut}
            let dineInMeals = meals.filter{ $0.mealType == .dineIn}
            
            return (dineOutMeals, dineInMeals, shoppings)
        })
        .asDriver(onErrorJustReturn: ([], [], []))
        
        let updateDataBySelectedDates = Observable.combineLatest(meals, shoppings, selectedDates , resultSelector: { meals, shoppings, selectedDates -> ([Meal], [Meal], [GroceryShopping]) in
            var dineOutMeals = meals.filter{ $0.mealType == .dineOut}
            var dineInMeals = meals.filter{ $0.mealType == .dineIn}
            var shoppings = shoppings
            let dates = selectedDates.map{ $0.dateToString() }
            
            for i in 0...dates.count {
                shoppings = shoppings.filter{ $0.date.dateToString() == dates[i] }
                dineOutMeals = dineOutMeals.filter{ $0.date.dateToString() == dates[i]}
                dineInMeals = dineInMeals.filter{ $0.date.dateToString() == dates[i] }
            }
            
            return (dineOutMeals, dineInMeals, shoppings)
        })
        .asDriver(onErrorJustReturn: ([], [], []))
        
        self.input = Input(selectedDates: selectedDates)
        self.output = Output(averagePrice: averagePrice, updateData: updateData, updateDataBySelectedDates: updateDataBySelectedDates)
    }
    
}
