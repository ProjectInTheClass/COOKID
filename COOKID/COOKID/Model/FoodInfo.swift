//
//  FoodInfo.swift
//  COOKID
//
//  Created by 김동환 on 2021/05/03.
//

import Foundation
import UIKit

enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case brunch = "아점"
    case lunch = "점심"
    case lundinner = "점저"
    case dinner = "저녁"
    case snack = "간식"
}

enum Category: String, CaseIterable {
    
    case rice
    case snack
    case noodle
    case stew
    case steamedDish
    case diary
    case fruit
    case riceCake
    case friedFood
}

struct FoodInfo {
    
    let foodImage: UIImage //uiImage
    let mealType: MealType
    let eatOut: Bool
    let foodName: String
    let price: Int
    let category: Category
}

