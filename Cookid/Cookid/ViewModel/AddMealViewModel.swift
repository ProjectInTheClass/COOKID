//
//  AddMealViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/02.
//

import Foundation
import RxSwift
import RxCocoa

class AddMealViewModel: ViewModelType {
    
    let mealService: MealService
    let userService: UserService
    
    struct Input {
        let isDineIn: BehaviorSubject<Bool>
        let mealName: BehaviorSubject<String>
        let mealDate: BehaviorSubject<Date>
        let mealTime: BehaviorSubject<MealTime>
        let mealType: BehaviorSubject<MealType>
        let mealPrice: BehaviorSubject<String>
    }
    
    struct Output {
        let newMeal: Driver<Meal>
        let validation: Driver<Bool>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService) {
        self.mealService = mealService
        self.userService = userService
        
        userService.loadUserInfo { user in
            mealService.fetchMeals(user: user) { _ in  }
        }
        
        let isDineIn = BehaviorSubject<Bool>(value: false)
        let mealName = BehaviorSubject<String>(value: "")
        let mealDate = BehaviorSubject<Date>(value: Date())
        let mealTime = BehaviorSubject<MealTime>(value: .breakfast)
        let mealType = BehaviorSubject<MealType>(value: .dineIn)
        let mealPrice = BehaviorSubject<String>(value: "")
        
        let validation = Observable.combineLatest(mealName, mealPrice, mealType) { name, price, type -> Bool in
            
            if type == .dineOut {
                guard name != "",
                      mealService.validationNum(text: price) else { return false }
            } else {
                guard name != "" else { return false }
            }
            return true
        }
        .asDriver(onErrorJustReturn: false)
        
        let newMeal = Observable.combineLatest(isDineIn, mealName, mealDate, mealTime, mealType, mealPrice) { isDineIn, mealName, mealDate, mealTime, mealType, mealPrice in
            
            let validMealPrice = Int(mealPrice) ?? 0
            
            return Meal(id: UUID().uuidString, price: validMealPrice, date: mealDate, name: mealName, image: nil, mealType: mealType, mealTime: mealTime)
        }
        .asDriver(onErrorJustReturn: DummyData.shared.mySingleMeal)
        
        self.input = Input(isDineIn: isDineIn, mealName: mealName, mealDate: mealDate, mealTime: mealTime, mealType: mealType, mealPrice: mealPrice)
        
        self.output = Output(newMeal: newMeal, validation: validation)
    }

    
}
