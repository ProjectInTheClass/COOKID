//
//  DummyData.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class DummyData {
    static let shared = DummyData()
    
    var mySingleMeal = Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .lunch)
    
    var mySingleShopping = GroceryShopping(date: Date(),
                                           groceries: [Grocery(name: "가지", price: 1000),
                                                       Grocery(name: "호박", price: 1500),
                                                       Grocery(name: "만가닥버섯", price: 800)
                                           ])
    
    var myMeals = [
        Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .lunch),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .dinner),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineOut, mealTime: .breakfast),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineIn, mealTime: .brunch),
        Meal(price: 8000, date: Date(), name: "순대국밥", image: UIImage(systemName: "photo.on.rectangle.angled")!, mealType: .dineIn, mealTime: .snack)]
    
    var singleUser = User(userID: nil, nickname: "천가닥버섯", determination: "아자아자", priceGoal: "100000", userType: .preferDineIn)
    
    var myShoppings = [GroceryShopping]()
    
    func dineInProgressCalc(meals: [Meal]) -> CGFloat {
        let newMeals = meals.filter { $0.mealType == .dineIn }
        return CGFloat(newMeals.count) / CGFloat(meals.count)
    }
    
    func mostExpensiveMeal(meals: [Meal]) -> Meal? {
        let newMeals = meals.sorted { $0.price > $1.price }
        return newMeals.first
    }
    
    func recentMeals(meals: [Meal]) -> [Meal] {
        guard let aWeekAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date()) else { return [] }
        let recentMeals = meals.filter { $0.date > aWeekAgo }
        let sortedMeals = recentMeals.sorted { $0.date > $1.date }
        return sortedMeals
    }
    
    func mealTimesCalc(meals: [Meal]) -> [Int] {
        
        let breakfastNum = meals.filter { $0.mealTime == .breakfast}.count
        let brunchNum = meals.filter { $0.mealTime == .brunch}.count
        let lunchNum = meals.filter { $0.mealTime == .lunch}.count
        let lundinnerNum = meals.filter { $0.mealTime == .lundinner}.count
        let dinnerNum = meals.filter { $0.mealTime == .dinner}.count
        let snackNum = meals.filter { $0.mealTime == .snack}.count
        
        return [breakfastNum, brunchNum, lunchNum, lundinnerNum, dinnerNum, snackNum]
    }
    
}
