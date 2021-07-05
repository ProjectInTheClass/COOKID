//
//  Meal.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class Meal {
    
    let id: String = UUID().uuidString // UUID?
    var price: Int
    var date: Date
    var name: String
    var image: UIImage
    var mealType: MealType
    var mealTime: MealTime
    
    init(price: Int, date: Date, name: String, image: UIImage, mealType: MealType, mealTime: MealTime) {
        self.price = price
        self.date = date
        self.name = name
        self.image = image
        self.mealType = mealType
        self.mealTime = mealTime
    }
    
}

enum MealType {
    case dineOut
    case dineIn
}

enum MealTime {
    case breakfast
    case brunch
    case lunch
    case lundinner
    case dinner
    case snack
}

struct GroceryShopping {
    let date: Date
    var groceries: [Grocery]
    
    func totalPrice(groceries: [Grocery]) -> Int {
        return self.groceries.reduce(0) { result, grocery in
            result + grocery.price
        }
    }
}

struct Grocery {
    let name: String
    let price: Int
}

