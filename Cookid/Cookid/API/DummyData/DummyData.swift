//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()

    var mySingleMeal = Meal(id: "", price: 12000, date: Date(), name: "생선구이", image: UIImage(named: "salad"), mealType: .dineOut, mealTime: .lunch)

    var mySingleShopping = GroceryShopping(id: UUID().uuidString, date: Date(), totalPrice: 10000)

    var singleUser = User(id: "", nickname: "비회원님", determination: "회원정보가 입력되지 않았습니다.", priceGoal: 0, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)

}
