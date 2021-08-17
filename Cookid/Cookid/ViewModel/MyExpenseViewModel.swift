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
        let selectedDates : BehaviorSubject<[Date]>
    }
    
    struct Output {
        let averagePrice: Driver<String>
        let updateData: Driver<([Meal], [Meal], [GroceryShopping])>
        let updateDataBySelectedDates: Driver<[MealShoppingItemSectionModel]>
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
        
        let selectedDates = BehaviorSubject<[Date]>(value: [Date()])
        
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
        
        let updateDataBySelectedDates = Observable.combineLatest(meals, shoppings, selectedDates , resultSelector: { meals, shoppings, selectedDates -> [MealShoppingItemSectionModel] in
            var dineOutMeals = meals.filter{ $0.mealType == .dineOut}
            var dineInMeals = meals.filter{ $0.mealType == .dineIn}
            var shoppings = shoppings
            let dates = selectedDates.map{ $0.dateToString() }
            
            var dineOutItems : [MealShoppingSectionItem]? = [MealShoppingSectionItem]()
            var dineInItems : [MealShoppingSectionItem]? = [MealShoppingSectionItem]()
            var shoppingItems : [MealShoppingSectionItem]? = [MealShoppingSectionItem]()
            
            
            for i in 0..<dates.count {
                shoppings = shoppings.filter{ $0.date.dateToString() == dates[i] }
                dineOutMeals = dineOutMeals.filter{ $0.date.dateToString() == dates[i]}
                dineInMeals = dineInMeals.filter{ $0.date.dateToString() == dates[i] }
            }
            
            for i in 0..<dineOutMeals.count {
                dineOutItems?.append(.DineOutSectionItem(item: dineOutMeals[i]))
            }
            
            for i in 0..<dineInMeals.count {
                dineInItems?.append(.DineInSectionItem(item: dineInMeals[i]))
            }
            
            for i in 0..<shoppings.count {
                shoppingItems?.append(.ShoppingSectionItem(item: shoppings[i]))
            }
            
            let sections: [MealShoppingItemSectionModel] = [
                .DineOutSection(title: "외식", items: dineOutItems ?? []),
                .DineInSection(title: "집밥", items: dineInItems ?? []),
                .ShoppingSection(title: "마트털이", items: shoppingItems ?? [])
            ]
            
            return sections
        })
        .asDriver(onErrorJustReturn: [])
        
        self.input = Input(selectedDates: selectedDates)
        self.output = Output(averagePrice: averagePrice, updateData: updateData, updateDataBySelectedDates: updateDataBySelectedDates)
    }
}

//SectionModel
enum MealShoppingItemSectionModel {
    case DineOutSection(title : String, items: [MealShoppingSectionItem])
    case DineInSection(title : String, items: [MealShoppingSectionItem])
    case ShoppingSection(title : String, items: [MealShoppingSectionItem])
}

enum MealShoppingSectionItem {
    case DineOutSectionItem(item: Meal)
    case DineInSectionItem(item: Meal)
    case ShoppingSectionItem(item: GroceryShopping)
}

extension MealShoppingItemSectionModel: SectionModelType {
    typealias Item = MealShoppingSectionItem
    
    var items: [Item] {
        switch self {
        case .DineOutSection(title: _, items: let items):
            return items.map { $0 }
        case .DineInSection(title: _, items: let items):
            return items.map { $0 }
        case .ShoppingSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    var title: String {
        switch self {
        case .DineInSection:
            return "집밥"
        case .DineOutSection:
            return "외식"
        case .ShoppingSection:
            return "마트털이"
        }
    }
    
    init(original: MealShoppingItemSectionModel, items: [Item]) {
        switch original {
        case let .DineOutSection(title: title, items: _):
            self = .DineOutSection(title: title, items: items)
        case let .DineInSection(title: title, items: _):
            self = .DineInSection(title: title, items: items)
        case let .ShoppingSection(title: title, items: _):
            self = .ShoppingSection(title: title, items: items)
        }
    }
}

typealias MealShoppingDataSource = RxTableViewSectionedReloadDataSource<MealShoppingItemSectionModel>

