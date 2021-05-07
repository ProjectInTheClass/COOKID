//
//  FoodInfoViewModel.swift
//  COOKID
//
//  Created by 김동환 on 2021/05/03.
//

import Foundation

class FoodListManager {
    
    static let shared = FoodListManager()
    static var lastId = 0
    
//    var foods = [Food]()
//    
//    func createFood(detail: String, isToday: Bool, isDone: Bool) -> Food {
//        let nextId = FoodListManager.lastId + 1
//        FoodListManager.lastId = nextId
//        return Food(foodImage: <#T##UIImage#>, mealType: <#T##MealType#>, foodName: <#T##String#>, price: <#T##Int#>, category: <#T##Category#>, date: <#T##Date#>)
//    }
//    
//    func addFood(_ food: Food) {
//        foods.append(food)
//        saveTodo()
//    }
//    
//    func deleteFood(_ food: Food){
//        foods = foods.filter{$0.id != todo.id}
//        saveTodo()
//    }
//    
//    func updateFood(_ todo: Todo){
//        guard let index = todos.firstIndex(of: todo) else {return}
//        self.todos[index].update(detail: todo.detail, isToday: todo.isToday, isDone: todo.isDone)
//        saveTodo()
//    }
//    
//    func saveFood(){
//        Storage.store(todos, to: .documents, as: "todos.json")
//    }
//    
//    func retrieveFood(){
//        todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
//        
//        let lastId = todos.last?.id ?? 0
//        TodoManager.lastId = lastId
//    }
//    
//    
//}
//
//class FoodListViewModel {
//
//    var foodListViewModel: [FoodViewModel]
//
//    init() {
//        self.foodListViewModel = [FoodViewModel]()
//    }
//
//    var numberOfFood: Int {
//        return foodListViewModel.count
//    }
//
//    func foodViewModel(at index: Int) -> FoodViewModel{
//        return self.foodListViewModel[index]
//    }
//
//}
//
//struct FoodViewModel {
//    let foodInfo: Food
//}
//
//extension FoodViewModel {
//
//    var mealType: String {
//        return foodInfo.mealType.rawValue
//    }
//
//    var foodName: String {
//        return foodInfo.foodName
//    }
//
//}
