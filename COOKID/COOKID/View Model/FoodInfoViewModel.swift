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
    
    var foods = [Food]()
    
    
}

class FoodListViewModel {
    
    var foodListViewModel: [FoodViewModel]
    
    init() {
        self.foodListViewModel = [FoodViewModel]()
    }
    
    var numberOfFood: Int {
        return foodListViewModel.count
    }
    
    func foodViewModel(at index: Int) -> FoodViewModel{
        return self.foodListViewModel[index]
    }
    
}

struct FoodViewModel {
    let foodInfo: Food
}

extension FoodViewModel {
    
    var mealType: String {
        return foodInfo.mealType.rawValue
    }

    var foodName: String {
        return foodInfo.foodName
    }
    
}
