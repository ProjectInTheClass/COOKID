//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()
    
    var mySingleMeal = Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .lunch)
    
    var mySingleShopping = GroceryShopping(date: Date(),
                                           groceries: [Grocery(name: "가지", price: 1000),
                                                       Grocery(name: "호박", price: 1500),
                                                       Grocery(name: "만가닥버섯", price: 800)
                                           ])
    
    var myMeals = [
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .breakfast),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .breakfast),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .breakfast),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineIn, mealTime: .brunch),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineIn, mealTime: .snack)]
    
    var singleUser = User(userID: nil, nickname: "천가닥버섯", determination: "아자아자", priceGoal: "100000", userType: .preferDineIn)
    
    var myShoppings = [GroceryShopping]()
    
    func dateToMeal(date: Date) -> [Meal] {
        return DummyData.shared.myMeals
    }
    
}
