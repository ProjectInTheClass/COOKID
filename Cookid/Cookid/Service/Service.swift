//
//  Service.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/06.
//

import Foundation

class Service {
    
//service testing
    
//    var delegate: PassingSpend?
    var currentSpend: Int = 0
    var meals: [Meal] = []
    var totalBudget: Int = 0
    var shoppingSpend: Int = 0
    var eatOutSpend: Int = 0
    
    func addShoppingSpend(price: Int){
        self.shoppingSpend += price
        self.currentSpend += price
    }
    
    func addEatOutSpend(price: Int){
        self.eatOutSpend += price
        self.currentSpend += price
    }
    
    func addMeal(meal: Meal){
        self.meals.append(meal)
        self.calculate(meal: meal) { spend in
         
        }
    }
    
    func calculate(meal: Meal , completion: @escaping (Spend) -> Void){
        if meal.mealType == .dineIn {
            self.addShoppingSpend(price: meal.price)
        } else {
            self.addEatOutSpend(price: meal.price)
        }
        
        let spend = Spend(total: currentSpend, shopping: shoppingSpend, eatOut: eatOutSpend, percentage: Int(currentSpend) / Int(totalBudget) * 100)
        completion(spend)
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
