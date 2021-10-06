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
    
    lazy var posts = [Post]()
    
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!, URL(string: "https://cdn-square.bizhost.kr/files/promo_img/210909_adidaspng.png")!], star: 5, caption: "제주도 맛집! 완전 추천! 여기 진짜 맛있었어요. 가격도 적당하고 대충 3-4만원 정도 예상하고 가시면 되는데, 진짜 완전완전 강추입니다:) 꼭 가보세요!  꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요! 꼭 가보세요!", mealBudget: 30, location: "경기"),
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], star: 1, caption: "조금 비싼 라면.. 하지만 맛있어요", mealBudget: 12000, location: "제주도"),
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], star: 5, caption: "oh! no!", mealBudget: 1241, location: "전주"),
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], star: 4, caption: "oh! no!", mealBudget: 5000, location: "부산"),
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!], star: 2, caption: "oh! no!", mealBudget: 80000, location: "경북"),
//        Post(postID: UUID().uuidString, user: singleUser, images: [URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1234&q=80")!, URL(string: "https://cdn-square.bizhost.kr/files/promo_img/210909_adidaspng.png")!], star: 3, caption: "oh! no!", mealBudget: 5000000, location: "문경")
}
