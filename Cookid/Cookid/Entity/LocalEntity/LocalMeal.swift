//
//  LocalMeal.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class LocalMeal: Object {
    @Persisted var id: String
    @Persisted var price: Int
    @Persisted var date: Date
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var mealType: String
    @Persisted var mealTime: String
    
    convenience init(id: String, price: Int, date: Date, name: String, image: String, mealType: String, mealTime: String) {
        self.init()
        self.id = id
        self.price = price
        self.date = date
        self.name = name
        self.image = image
        self.mealType = mealType
        self.mealTime = mealTime
    }
}
