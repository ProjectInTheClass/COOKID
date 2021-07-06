//
//  Entities.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation


struct MealEntity: Codable {
    var id: String?
    var price: Int
    var date: String
    var name: String
    var image: String?
    var mealType: String
    var mealTime: String
    
    init(mealDic: [String:Any]) {
        self.price = mealDic["price"] as? Int ?? 0
        self.date = mealDic["date"] as? String ?? ""
        self.name = mealDic["name"] as? String ?? ""
        self.image = mealDic["image"] as? String ?? ""
        self.mealType = mealDic["mealType"] as? String ?? ""
        self.mealTime = mealDic["mealTime"] as? String ?? ""
    }
}


struct GroceryEntity: Codable {
    var date: Int
    var groceries: [String]
    
    init(groceriesDic: [String:Any]) {
        self.date = groceriesDic["date"] as? Int ?? 0
        self.groceries = groceriesDic["groceries"] as? [String] ?? []
    }
}


struct UserEntity: Codable {
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: String
    
    init(userDic: [String:Any]) {
        self.nickname = userDic["nickname"] as? String ?? ""
        self.determination = userDic["determination"] as? String ?? ""
        self.priceGoal = userDic["priceGoal"] as? Int ?? 0
        self.userType = userDic["userType"] as? String ?? ""
    }
}
