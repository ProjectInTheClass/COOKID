//
//  BaseViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/01.
//

import Foundation

class BaseViewModel {
    let userService: UserServiceType
    let mealService: MealServiceType
    let shoppingService: ShoppingServiceType
    init(userService: UserServiceType,
         mealService: MealServiceType,
         shoppingService: ShoppingServiceType) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
    }
}
