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

    var singleUser = User(id: "", nickname: "비회원님", determination: "회원정보가 입력되지 않았습니다.", priceGoal: 40000, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)
    
    // swiftlint:disable line_length
    lazy var posts = [
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!, URL(string: "https://images.unsplash.com/photo-1597484389225-c68a9f0fa106?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=686&q=80")!], caption: "제주도 맛집! 완전 추천! 여기 진짜 맛있었어요. 가격도 적당하고 대충 3-4만원 정도 예상하고 가시면 되는데, 진짜 완전완전 강추입니다:) 꼭 가보세요!", mealBudget: 3000, location: "제주도"),
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], caption: "조금 비싼 라면.. 하지만 맛있어요", mealBudget: 3000, location: "제주도"),
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], caption: "oh! no!", mealBudget: 1241, location: "전주"),
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], caption: "oh! no!", mealBudget: 5000, location: "부산"),
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], caption: "oh! no!", mealBudget: 40000, location: "경북"),
        Post(user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], caption: "oh! no!", mealBudget: 5000000, location: "문경")
    ]
    // swiftlint:enable line_length
}
