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

class Service {
  
    // 필요한 것 - 현재까지 총 소비한 것을 줌
    // - 쇼핑한 것의 총 비용
    // - 외식한 것의 총 비용
    // - 버짓을 줌
    var meals: [Meal] = []
    var totalBudget: Int = 0
    
    
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
    
    func addMeal(meal: Meal){
        self.meals.append(meal)
    }
    
    func dineInProgressCalc(meals: [Meal]) -> CGFloat {
            let newMeals = meals.filter { $0.mealType == .dineIn }
            return CGFloat(newMeals.count/meals.count)
        }
    
    //MARK: - MainDashViewModel
    
    func fetchMeals(completion: @escaping ((Meal) -> Void)){
        //레파지토리 통신
    }
  
}

struct Spend {
    let total: Int
    let shopping: Int
    let eatOut: Int
    let percentage: Int
}
