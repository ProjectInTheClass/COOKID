//
//  ShoppingService.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation
import RxSwift

class ShoppingService {
    
    private let groceryRepository = GroceryRepository()
    
    private var groceryShoppings: [GroceryShopping] = []
    
    private lazy var shoppingStore = BehaviorSubject<[GroceryShopping]>(value: groceryShoppings)
    
    
    @discardableResult
    func create(date: Date, price: Int) -> Observable<GroceryShopping> {
        return Observable.empty()
    }
    
    @discardableResult
    func mealList() -> Observable<[GroceryShopping]> {
        return Observable.empty()
    }
    
    @discardableResult
    func update(shopping: GroceryShopping, date: Date, price: Int) -> Observable<GroceryShopping> {
        return Observable.empty()
    }
    
    @discardableResult
    func delete(shopping: GroceryShopping) -> Observable<GroceryShopping> {
        return Observable.empty()
    }
    
    func fetchGroceries(completion: @escaping (([GroceryShopping]) -> Void)) {
        groceryRepository.fetchGroceryInfo { models in
            let groceryShoppings = models.map { shoppingModel -> GroceryShopping in
                
                let date = stringToDate(date: shoppingModel.date)
                
                let totalPrice = shoppingModel.totalPrice
                
                return GroceryShopping(date: date, totalPrice: totalPrice)
            }
            self.groceryShoppings = groceryShoppings
            completion(groceryShoppings)
        }
    }
    
    func fetchShoppingSpend(meals: [Meal]) -> Int {
        let shoppingSpends = meals.filter {$0.mealType == .dineIn}.map{$0.price}
        let totalSpend = shoppingSpends.reduce(0){$0+$1}
        return totalSpend
    }

}
