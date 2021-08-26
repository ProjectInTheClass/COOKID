//
//  Meal.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxDataSources

class Meal: Equatable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return true
    }
    var id: String
    var price: Int
    var date: Date
    var name: String
    var image: URL?
    var mealType: MealType
    var mealTime: MealTime
    
    init(id: String, price: Int, date: Date, name: String, image: URL?, mealType: MealType, mealTime: MealTime) {
        self.id = id
        self.price = price
        self.date = date
        self.name = name
        self.image = image
        self.mealType = mealType
        self.mealTime = mealTime
    }
}

enum MealType: String {
    case dineOut = "외식"
    case dineIn = "집밥"
}

enum MealTime: String, CaseIterable {
    case breakfast = "아침"
    case brunch = "아점"
    case lunch = "점심"
    case lundinner = "점저"
    case dinner = "저녁"
    case snack = "간식"
}

struct MealSection {
    typealias Item = Meal
   
    var header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension MealSection: SectionModelType {
    init(original: MealSection, items: [Item]) {
        self = original
        self.items = items
    }
}
