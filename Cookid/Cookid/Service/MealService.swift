//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import UIKit

// 날짜 앞뒤로 넘어가면서 가져오는 함수
// 리포 패치
// 서비스 나누기

class MealService {
    
    static let shared = MealService()
    
    private let mealRepository = MealRepository()
    private let userRepository = UserRepository()
    private let groceryRepository = GroceryRepository()
    
    private var meals: [Meal] = []
    private var groceries: [GroceryShopping] = []
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
    
    func fetchMeals(completion: @escaping (([Meal]) -> Void)) {
        mealRepository.fetchMeals { mealArr in
            
            let mealModels = mealArr.map { model -> Meal in
                let price = model.price
                let date = model.date.stringToDate()!
                let name = model.name
                let image = model.image ?? "https://plainbackground.com/download.php?imagename=ffffff.png"
                let mealType = MealType(rawValue: model.mealType) ?? .dineIn
                let mealTime = MealTime(rawValue: model.mealTime) ?? .dinner
                
                return Meal(price: price, date: date, name: name, image: image, mealType: mealType, mealTime: mealTime)
            }
            self.meals = mealModels
            completion(mealModels)
        }
    }
    
    func fetchGroceries(completion: @escaping (([GroceryShopping]) -> Void)) {
        groceryRepository.fetchGroceryInfo { models in
            
            let groceryShoppings = models.map { shoppingModel -> GroceryShopping in
                let date = self.stringToDate(date: shoppingModel.date)
                let groceries = shoppingModel.groceries.map { entityModel in
                    return Grocery(name: entityModel.name, price: entityModel.price)
                }
                return GroceryShopping(date: date, groceries: groceries)
            }
            self.groceries = groceryShoppings
            completion(groceryShoppings)
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
    
    func mealTimesCalc(meals: [Meal]) -> [[Meal]] {
        
        let breakfastNum = meals.filter { $0.mealTime == .breakfast}
        let brunchNum = meals.filter { $0.mealTime == .brunch}
        let lunchNum = meals.filter { $0.mealTime == .lunch}
        let lundinnerNum = meals.filter { $0.mealTime == .lundinner}
        let dinnerNum = meals.filter { $0.mealTime == .dinner}
        let snackNum = meals.filter { $0.mealTime == .snack}
        
        return [breakfastNum, brunchNum, lunchNum, lundinnerNum, dinnerNum, snackNum]
    }
    
    var currentDay = Date()
    
    func fetchMealByDay(day: Int) -> [Meal] {
        
        guard let aDay = Calendar.current.date(byAdding: .day, value: day, to: currentDay) else { return [] }
        currentDay = aDay
        let meal = self.meals.filter {$0.date == currentDay }
        return meal
    }
    
    
    //현재 지출 현황을 보고 페이스를 넘었으면 경고하는 String을 뱉어준다
    func checkPace() -> String{
        
        //전체 지출을 현재 달의 날짜 숫자로 나누면 하루당 써야하는 퍼센트가 나온다.
        //그 퍼센트가 일정 기준을 넘었을 때 , 워닝을 띄운다
        
        
        return ""
    }
    
    
}
