//
//  FoodInfoViewModel.swift
//  COOKID
//
//  Created by 김동환 on 2021/05/03.
//

import Foundation
import UIKit

class FoodManager {
    
    static let shared = FoodManager()
    static var lastId = 0
    
    var foods = [Food]()
    
    func createFood(foodName: String, mealType: MealType, eatOut: Bool, price: Int, category: Category, date: Date, foodImage: UIImage) -> Food {
        let nextId = FoodManager.lastId + 1
        FoodManager.lastId = nextId
        
        let food = Food(id: nextId, foodImage: foodImage.pngData()!, mealType: mealType, eatOut: eatOut, foodName: foodName, price: price, category: category, date: date)
        
        return food
    }
    
    
    func addFood(_ food: Food) {
        foods.append(food)
        saveFood()
    }
    
    func deleteFood(_ food: Food){
        foods = foods.filter{$0.id != food.id}
        saveFood()
    }
    
    func updateFood(_ food: Food){
        guard let index = foods.firstIndex(of: food) else {return}
        self.foods[index].updateFood(food)
        saveFood()
    }
    
    func saveFood(){
        Storage.store(foods, to: .documents, as: "foods.json")
    }
    
    func retrieveFood(){
        foods = Storage.retrive("foods.json", from: .documents, as: [Food].self) ?? []
        
        let lastId = foods.last?.id ?? 0
        FoodManager.lastId = lastId
    }
}

class FoodListViewModel {
    
    
    private let manager = FoodManager.shared
    
    var foods: [Food] {
        return manager.foods
    }
    
    func updateFood(_ food : Food){
        manager.updateFood(food)
    }
    
    func deleteFood(_ food : Food) {
        manager.deleteFood(food)
    }
    
    func addFood(_ food: Food){
        manager.addFood(food)
    }
    
    func retrieveFood(){
        manager.retrieveFood()
    }
}
