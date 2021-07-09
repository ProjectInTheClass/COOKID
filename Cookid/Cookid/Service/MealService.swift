//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import UIKit

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
        
        let monthString = self.convertDateToString(format: "M", date: Date())
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
    
    func mostExpensiveMealAlert(meal: Meal) -> String? {
        
        guard let mostExpensiveYet = self.mostExpensiveMeal(meals: self.meals) else {return nil}
        if meal.price > mostExpensiveYet.price {

            return "FOOD FLEX 하셨습니다"
        }
      
     return nil
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
    

    func fetchMealByNavigate(day: Int) -> (String, [Meal]) {
        
        guard let aDay = Calendar.current.date(byAdding: .day, value: day, to: currentDay) else { return ("", []) }
        currentDay = aDay
        let dateString = self.convertDateToString(format: "YYYY년 M월 d일", date: currentDay)
        let meal = self.meals.filter {$0.date == currentDay }

        return (dateString, meal)
    }
    

    func fetchMealByDay(day: Date) -> [Meal] {
        let meal = self.meals.filter {$0.date == day}
        return meal
    } 
    
    func checkSpendPace() -> String{

        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        guard let day = components.day else {return ""}
        let percentage = self.getSpendPercentage()
        
        switch day {
        case 1...7:
            if percentage < 25 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 50 {
                return "아직 (다음주에 덜 먹으면) 괜찮아요 👏"
            } else if percentage < 80 {
                return "첫 주에 절반 이상을 태워..? 👮🏻‍♂️"
            } else if percentage < 100 {
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 8...14:
            if percentage < 50 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 75 {
                return "아직 (다음주에 덜 먹으면) 괜찮아요 👏"
            } else if percentage < 90 {
                return "다음주에 굶으시려나보다 🙋🏻‍♂️"
            } else if percentage < 100{
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 15...21:
            if percentage < 80 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 90{
                return "조금만 조절하면 당신은 현명한 소비자 💵"
            } else if percentage < 100 {
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        case 22...28:
            if percentage < 90 {
                return "현명한 식비 관리 중입니다 👍"
            } else if percentage < 100{
                return "예산을 곧 초과합니다 🚨"
            } else {
                return "(절레절레) 🤷🏻‍♂️"
            }
        default:
            if percentage < 100 {
                return "어..? 예쁘다 💐"
            } else {
                return "예산을 초과했습니다 🚨"
            }
        }
    }
    
    func fetchMealByDay(day: Date) -> [Meal] {
        let meal = self.meals.filter {$0.date == day}
        return meal

    private func convertDateToString(format: String, date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString

    }
    
    private func stringToDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: date)
        
        return date!
    }
}
