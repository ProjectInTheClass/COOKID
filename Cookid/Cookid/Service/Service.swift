//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import UIKit

class Service {
    
    private let mealRepository = MealRepository()
    private let userRepository = UserRepository()
    private let groceryRepository = GroceryRepository()
    
    private var meals: [Meal] = []
    private var totalBudget: Int = 0
    
    func addMeal(meal: Meal){
        self.meals.append(meal)
    }
    
    func setTotalBudget(budget: Int) {
        self.totalBudget = budget
    }
    
    func fetchCurrentSpend() -> Int {
        let totalSpend = self.meals.map{$0.price}.reduce(0){$0+$1}
        return totalSpend
    }
    
    func fetchShoppingSpend() -> Int {
        let shoppingSpends = meals.filter {$0.mealType == .dineIn}.map{$0.price}
        let totalSpend = shoppingSpends.reduce(0){$0+$1}
        return totalSpend
    }
    
    func fetchEatOutSpend() -> Int {
        let eatOutSpends = meals.filter {$0.mealType == .dineOut}.map{$0.price}
        let totalSpend = eatOutSpends.reduce(0){$0+$1}
        return totalSpend
    }
    
    func getSpendPercentage() -> Int {
        return self.fetchCurrentSpend() / totalBudget * 100
    }
    
    func fetchCurrentMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let monthString = dateFormatter.string(from: date)
        return monthString
    }
    
    func fetchAverageSpendPerDay() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        guard let dayOfMonth = components.day else {return 1}
        let average = self.fetchCurrentSpend() / dayOfMonth
        return average
    }
    
    private func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: date)
        
        return date!
    }
    
    func fetchMeals(completion: @escaping ((Meal) -> Void)) {
        mealRepository.fetchMeals { mealArr in

            let mealModels = mealArr.map { model -> Meal in
                let price = model.price
                let date = self.stringToDate(date: model.date)
                let name = model.name
                let image = model.image ?? "https://plainbackground.com/download.php?imagename=ffffff.png"
                let mealType = MealType(rawValue: model.mealType)!
                let mealTime = MealTime(rawValue: model.mealTime)!
                let mealModel = Meal(price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
                return mealModel
            }
            self.meals = mealModels
        }
    }
    
    func fetchGroceries(completion: @escaping ((Grocery) -> Void)) {
        
        groceryRepository.fetchGroceryInfo { model in
            
        }
        
    }
    
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
