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
    
    lazy var singlePost = Post(postID: UUID().uuidString, user: singleUser,
                               images: [
                                URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!,
                                URL(string: "https://cdn-square.bizhost.kr/files/promo_img/210909_adidaspng.png")!
                               ], likes: 35302, collections: 2300, star: 5, caption: "제주도 맛집!", mealBudget: 60000, location: "제주도", timeStamp: Date(), didLike: true, didCollect: true)
    
    lazy var posts = [Post]()

}
