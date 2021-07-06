//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()
    
    var mySingleMeal = Meal(price: 8000, date: Date(), name: "순대국밥", image: URL(string: "")!, mealType: .dineOut, mealTime: .lunch)
    
    var mySingleShopping = GroceryShopping(date: Date(),
                                           groceries: [Grocery(name: "가지", price: 1000),
                                                       Grocery(name: "호박", price: 1500),
                                                       Grocery(name: "만가닥버섯", price: 800)
                                           ])
    
    
    var myMeals = [Meal]()
    
    var myShoppings = [GroceryShopping]()
}
