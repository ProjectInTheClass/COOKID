//
//  MealService.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation

class MealService {
    
    static let shared = MealService()
    
    func loadMeal(completion: @escaping (Meal) -> Void) {
        MealRepository.shared.fetchMeals { mealEntity in
            var meals: Meal!
            
            for mealEntity in mealEntity {
                
                let urlString = mealEntity.image!
                let url = URL(string: urlString)!
                
                let meal = Meal(price: mealEntity.price,
                                date: mealEntity.date.StringTodate()!,
                                name: mealEntity.name,
                                image: url,
                                mealType: MealType(rawValue: mealEntity.mealType) ?? .dineIn,
                                mealTime: MealTime(rawValue: mealEntity.mealTime) ?? .breakfast)
                meals = meal
            }
            completion(meals)
        }
    }

}

