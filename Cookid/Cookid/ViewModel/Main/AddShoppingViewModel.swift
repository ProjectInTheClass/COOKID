//
//  AddShoppingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/25.
//

import Foundation
import RxCocoa
import RxSwift

class AddShoppingViewModel: ViewModelType {
    
    let shoppingService: ShoppingService
    let userService: UserService
    
    struct Input {
        let shoppingID: String?
        let shoppingDate: BehaviorRelay<Date>
        let shoppingPrice: BehaviorRelay<String>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let newShopping: Observable<GroceryShopping>
    }
    
    var input: Input
    var output: Output
    
    init(shoppingService: ShoppingService, userService: UserService, shoppingID: String? = nil) {
        self.shoppingService = shoppingService
        self.userService = userService
        
        let shoppingDate = BehaviorRelay<Date>(value: Date())
        let shoppingPrice = BehaviorRelay<String>(value: "")
        
        let validation = Observable.combineLatest(shoppingDate, shoppingPrice) { date, price -> Bool in
       
            if price == "" {
                return false
            } else {
                return true
            }
        }
        .asDriver(onErrorJustReturn: false)
        
        let newShopping = Observable.combineLatest(shoppingDate, shoppingPrice) { date, price -> GroceryShopping in
            
            let validMealPrice = Int(price) ?? 0
            
            return GroceryShopping(id: shoppingID ?? "", date: date, totalPrice: validMealPrice)
        }
        
        self.input = Input(shoppingID: shoppingID, shoppingDate: shoppingDate, shoppingPrice: shoppingPrice)
        self.output = Output(validation: validation, newShopping: newShopping)
    }
    
}
