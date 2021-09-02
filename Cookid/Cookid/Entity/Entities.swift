//
//  Entities.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation

struct MealEntity: Codable {
    var id: String
    var price: Int
    var date: Int
    var name: String
    var image: String?
    var mealType: String
    var mealTime: String
    
    init(mealDic: [String:Any]) {
        self.id = mealDic["id"] as? String ?? ""
        self.price = mealDic["price"] as? Int ?? 0
        self.date = mealDic["date"] as? Int ?? 0
        self.name = mealDic["name"] as? String ?? ""
        self.image = mealDic["image"] as? String ?? ""
        self.mealType = mealDic["mealType"] as? String ?? ""
        self.mealTime = mealDic["mealTime"] as? String ?? ""
    }
}

struct GroceryEntity: Codable {
    let id: String
    var date: Int
    var totalPrice: Int
    
    init(groceriesDic: [String:Any]) {
        self.id = groceriesDic["id"] as? String ?? ""
        self.date = groceriesDic["date"] as? Int ?? 0
        self.totalPrice = groceriesDic["totalPrice"] as? Int ?? 0
    }
}

struct UserEntity: Codable {
    var userId: String
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: String
    
    init(userDic: [String:Any]) {
        self.nickname = userDic["nickname"] as? String ?? ""
        self.determination = userDic["determination"] as? String ?? ""
        self.priceGoal = Int(userDic["priceGoal"] as? String ?? "0")!
        self.userType = userDic["userType"] as? String ?? ""
        self.userId = userDic["userId"] as? String ?? ""
    }
}

struct UserAllEntity: Codable {
//    let groceries: [GroceryEntity]?
//    let meal: [MealEntity]?
    let user: UserEntity
    var totalCount: Int
    
}
