//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()

    var mySingleMeal = Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .lunch)

    var mySingleShopping = GroceryShopping(date: Date(), totalPrice: 10000)

    var myMeals = [
        Meal(price: 9000, date: Date(), name: "상하이버거", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .brunch),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .lunch),
        Meal(price: 30000, date: Date(), name: "광어회", image: "photo.on.rectangle.angled", mealType: .dineOut, mealTime: .lundinner),
        Meal(price: 1200, date: Date(), name: "젤리", image: "photo.on.rectangle.angled", mealType: .dineIn, mealTime: .breakfast),
        Meal(price: 25000, date: Date(), name: "아귀찜", image: "photo.on.rectangle.angled", mealType: .dineIn, mealTime: .dinner)]

    var singleUser = User(userID: "", nickname: "천가닥버섯", determination: "아자아자", priceGoal: "100000", userType: .preferDineIn)

    var myShoppings = [GroceryShopping]()

    func dateToMeal(date: Date) -> [Meal] {
        return DummyData.shared.myMeals
    }

    
    func findSelectedDateMealData (target : [Meal], selectedDate : Date) -> [Meal] {
                
        return target.filter{$0.date == selectedDate}
    }
    
    func findSelectedDateShoppingData (target : [GroceryShopping], selectedDate : Date) -> [GroceryShopping] {
        
        return target.filter{$0.date == selectedDate}
    }


}
