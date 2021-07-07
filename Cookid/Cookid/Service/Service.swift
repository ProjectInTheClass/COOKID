//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import Foundation

//총비용 전달 필요할 때 총 비용 전달
//함수 하나는 하나의 기능

//    하루평균 지출 금액구하기
//
//    날짜를 누르면 쇼핑한 리스트와 외식한 리스트가 나올 수 있는 함수
//
//    mealTime 사용 아침을 거른다
//    한번씩 더하는 것이 아니라 , 한꺼번에
//   현재 달을 리턴해주는 함수


class Service {
    
    let mealRepository = MealRepository()
    let userRepository = UserRepository()
    let groceryRepository = GroceryRepository()
    
    var meals: [Meal] = []
    var totalBudget: Int = 0
    
    func addMeal(meal: Meal){
        self.meals.append(meal)
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
    
    func fetchCurrentMonth() -> String{
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
        guard let dayOfMonth = components.day else {return}
        let average = self.fetchCurrentSpend() / dayOfMonth
        return average
    }
    
    private func stringToDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: date)
        
        return date!
    }
    
    func fetchMeals(completion: @escaping ((Meal) -> Void)){
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
}

struct Spend {
    let total: Int
    let shopping: Int
    let eatOut: Int
    let percentage: Int
}
