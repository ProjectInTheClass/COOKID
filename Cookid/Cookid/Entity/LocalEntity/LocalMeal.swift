//
//  LocalMeal.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class LocalMeal: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var price: Int
    @Persisted var date: Date
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var mealType: String
    @Persisted var mealTime: String
    
    convenience init(price: Int, date: Date, name: String, image: String, mealType: String, mealTime: String) {
        self.init()
        self.price = price
        self.date = date
        self.name = name
        self.image = image
        self.mealType = mealType
        self.mealTime = mealTime
    }
}
