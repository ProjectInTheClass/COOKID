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
        let mealImage: PublishRelay<UIImage?>
        let mealName: BehaviorRelay<String>
        let mealDate: BehaviorRelay<Date>
        let mealTime: BehaviorRelay<MealTime>
        let mealType: BehaviorRelay<MealType>
        let mealPrice: BehaviorRelay<String>
        let menus: BehaviorRelay<[Menu]>
    }
    
    struct Output {
        let newMeal: Observable<Meal>
        let validation: Driver<Bool>
    }
    
    var input: Input
    var output: Output
    
    init(mealService: MealService, userService: UserService, mealID: String? = nil) {
        self.mealService = mealService
        
        let mealImage = PublishRelay<UIImage?>()
        let mealName = BehaviorRelay<String>(value: "")
        let mealDate = BehaviorRelay<Date>(value: Date())
        let mealTime = BehaviorRelay<MealTime>(value: .breakfast)
        let mealType = BehaviorRelay<MealType>(value: .dineIn)
        let mealPrice = BehaviorRelay<String>(value: "")
        let menus = BehaviorRelay<[Menu]>(value: MenuService.shared.menus)
        
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
        
        let newMeal = Observable.combineLatest(mealImage, mealName, mealDate, mealTime, mealType, mealPrice) { image, name, date, mealTime, mealType, price -> Meal in
            
            let validMealPrice = Int(price) ?? 0

            return Meal(id: mealID ?? "", price: validMealPrice, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
        }
        
        self.input = Input(mealID: mealID, mealImage: mealImage, mealName: mealName, mealDate: mealDate, mealTime: mealTime, mealType: mealType, mealPrice: mealPrice, menus: menus)
        
        self.output = Output(newMeal: newMeal, validation: validation)
    }
}
