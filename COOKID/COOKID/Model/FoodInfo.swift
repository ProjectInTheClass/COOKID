//
//  FoodInfo.swift
//  COOKID
//
//  Created by 김동환 on 2021/05/03.
//

import Foundation
import UIKit

enum MealType: String, CaseIterable {
    case breakfast
    case brunch
    case lunch
    case lundinner
    case dinner
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

