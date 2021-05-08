//
//  FoodInfo.swift
//  COOKID
//
//  Created by 김동환 on 2021/05/03.
//

import Foundation
import UIKit

enum MealType: String, CaseIterable, Codable {
    case breakfast = "아침"
    case brunch = "아점"
    case lunch = "점심"
    case lundinner = "점저"
    case dinner = "저녁"
    case snack = "간식"
}

enum Category: String, CaseIterable, Codable {
    
    case rice = "밥류"
    case snack = "빵, 과자류"
    case noodle = "면류"
    case stew = "국, 찌개류"
    case steamedDish = "찜류"
    case diary = "우유 , 유제품"
    case fruit = "과일류"
    case riceCake = "떡류"
    case stirFriedFood = "볶음류"
    case friedFood = "튀김류"
}

struct Food: Codable, Equatable {
    
    let id: Int
    var foodImage: Data //uiImage
    var mealType: MealType
    var eatOut: Bool
    var foodName: String
    var price: Int
    var category: Category
    var date : Date
    
    mutating func updateFood(_ food: Food){
        self.foodImage = food.foodImage
        self.mealType = food.mealType
        self.eatOut = food.eatOut
        self.foodName = food.foodName
        self.price = food.price
        self.category = food.category
        self.date = food.date
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.id == rhs.id
    }
}

