//
//  LocalMeal.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift
import UIKit

class LocalMeal: Object {
    @Persisted var id: String
    @Persisted var price: Int
    @Persisted var date: Date
    @Persisted var name: String
    @Persisted var mealType: String
    @Persisted var mealTime: String
    
    convenience init(id: String, price: Int, date: Date, name: String, mealType: String, mealTime: String) {
        self.init()
        self.id = id
        self.price = price
        self.date = date
        self.name = name
        self.mealType = mealType
        self.mealTime = mealTime
    }
}

extension LocalMeal {
    func toDomain(image: UIImage?) -> Meal {
        let mealType = MealType(rawValue: mealType) ?? .dineIn
        let mealTime = MealTime(rawValue: mealTime) ?? .dinner
        return Meal(id: id, price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
    }
}
