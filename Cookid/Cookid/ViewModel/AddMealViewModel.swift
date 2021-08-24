//
//  AddMealViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/02.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class AddMealViewModel: ViewModelType, HasDisposeBag {
    
    let mealService: MealService
    
    struct Input {
        var mealID: String?
        let mealURL: BehaviorSubject<URL?>
        let isDineIn: BehaviorSubject<Bool>
        let mealName: BehaviorSubject<String>
        let mealDate: BehaviorSubject<Date>
        let mealTime: BehaviorSubject<MealTime>
        let mealType: BehaviorSubject<MealType>
        let mealPrice: BehaviorSubject<String>
    }
    
    struct Output {
        let newMeal: Observable<Meal>
        let validation: Driver<Bool>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, mealID: String? = nil) {
        self.mealService = mealService
        
        
        let mealURL = BehaviorSubject<URL?>(value: nil)
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
        
      
        let newMeal = Observable.combineLatest(mealService.fetchMealImageURL(mealID: mealID), isDineIn, mealName, mealDate, mealTime, mealType, mealPrice) { url, isDineIn, name, date, mealTime, mealType, price -> Meal in
            
            let validMealPrice = Int(price) ?? 0

            return Meal(id: mealID ?? "", price: validMealPrice, date: date, name: name, image: url, mealType: mealType, mealTime: mealTime)
        }
        
        self.input = Input(mealID: mealID, mealURL: mealURL, isDineIn: isDineIn, mealName: mealName, mealDate: mealDate, mealTime: mealTime, mealType: mealType, mealPrice: mealPrice)
        
        self.output = Output(newMeal: newMeal, validation: validation)
    }
}
