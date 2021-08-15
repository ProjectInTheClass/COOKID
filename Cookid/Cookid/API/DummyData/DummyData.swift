//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()

    var mySingleMeal = Meal(id: "", price: 12000, date: Date(), name: "생선구이", image: URL(string: "https://images.unsplash.com/photo-1625795839123-f689ff8740c3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80")!, mealType: .dineOut, mealTime: .lunch)

    var mySingleShopping = GroceryShopping(id: UUID().uuidString, date: Date(), totalPrice: 10000)

    var singleUser = User(userID: "", nickname: "천가닥버섯", determination: "아자아자", priceGoal: "100000", userType: .preferDineIn)

    var myMeals = [
        Meal(id: "nil", price: 9000, date: Date(), name: "상하이버거", image: URL(string: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .brunch),
        Meal(id: "nil", price: 8000, date: Date(), name: "순대국밥", image: URL(string: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .lunch),
        Meal(id: "nil", price: 30000, date: Date(), name: "광어회", image: URL(string: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .lundinner),
        Meal(id: "nil", price: 1200, date: Date(), name: "젤리", image: URL(string: "photo.on.rectangle.angled")!, mealType: .dineIn, mealTime: .breakfast),
        Meal(id: "nil", price: 25000, date: Date(), name: "아귀찜", image: URL(string: "photo.on.rectangle.angled")!, mealType: .dineIn, mealTime: .dinner)]

    var rankers = [
        User(userID: "", nickname: "임현지", determination: "아자아자!!", priceGoal: "100000", userType: .preferDineIn),
        User(userID: "", nickname: "김동환", determination: "아자아자!@@", priceGoal: "200000", userType: .preferDineOut),
        User(userID: "", nickname: "홍석현", determination: "아자아자!", priceGoal: "300000", userType: .preferDineIn),
        User(userID: "", nickname: "박형석", determination: "아자아자!!@", priceGoal: "400000", userType: .preferDineOut),
        User(userID: "", nickname: "임현지", determination: "아자아자!!", priceGoal: "100000", userType: .preferDineIn),
        User(userID: "", nickname: "김동환", determination: "아자아자!@@", priceGoal: "200000", userType: .preferDineOut),
        User(userID: "", nickname: "홍석현", determination: "아자아자!", priceGoal: "300000", userType: .preferDineIn),
        User(userID: "", nickname: "박형석", determination: "아자아자!!@", priceGoal: "400000", userType: .preferDineOut),
        User(userID: "", nickname: "임현지", determination: "아자아자!!", priceGoal: "100000", userType: .preferDineIn),
        User(userID: "", nickname: "김동환", determination: "아자아자!@@", priceGoal: "200000", userType: .preferDineOut),
        User(userID: "", nickname: "홍석현", determination: "아자아자!", priceGoal: "300000", userType: .preferDineIn),
        User(userID: "", nickname: "박형석", determination: "아자아자!!@", priceGoal: "400000", userType: .preferDineOut),
        User(userID: "", nickname: "임현지", determination: "아자아자!!", priceGoal: "100000", userType: .preferDineIn),
        User(userID: "", nickname: "김동환", determination: "아자아자!@@", priceGoal: "200000", userType: .preferDineOut),
        User(userID: "", nickname: "홍석현", determination: "아자아자!", priceGoal: "300000", userType: .preferDineIn),
        User(userID: "", nickname: "박형석", determination: "아자아자!!@", priceGoal: "400000", userType: .preferDineOut),
        User(userID: "", nickname: "임현지", determination: "아자아자!!", priceGoal: "100000", userType: .preferDineIn),
        User(userID: "", nickname: "김동환", determination: "아자아자!@@", priceGoal: "200000", userType: .preferDineOut),
        User(userID: "", nickname: "홍석현", determination: "아자아자!", priceGoal: "300000", userType: .preferDineIn),
        User(userID: "", nickname: "박형석", determination: "아자아자!!@", priceGoal: "400000", userType: .preferDineOut)
    ]



}
