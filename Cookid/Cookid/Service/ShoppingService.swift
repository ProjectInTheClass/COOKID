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
    func create(shopping: GroceryShopping) -> Observable<GroceryShopping> {
        
        groceryRepository.uploadGroceryInfo(grocery: shopping)
        
        groceryShoppings.append(shopping)
        shoppingStore.onNext(groceryShoppings)
        
        return Observable.just(shopping)
    }
    
    @discardableResult
    func shoppingList() -> Observable<[GroceryShopping]> {
        return shoppingStore
    }
    
    @discardableResult
    func update(updateShopping: GroceryShopping) -> Observable<GroceryShopping> {
        
         groceryRepository.uploadGroceryInfo(grocery: updateShopping)
        
        if let index = groceryShoppings.firstIndex(where: { $0.id == updateShopping.id }) {
            groceryShoppings.remove(at: index)
            groceryShoppings.insert(updateShopping, at: index)
        }
        
        shoppingStore.onNext(groceryShoppings)
        
        return Observable.just(updateShopping)
    }
    
    @discardableResult
    func delete(shopping: GroceryShopping) -> Observable<GroceryShopping> {
        
        // groceryRepository.deleteShoppingToFirebase(shopping: shopping)
        
        if let index = groceryShoppings.firstIndex(where: { $0.id == shopping.id }) {
            groceryShoppings.remove(at: index)
        }
        
        shoppingStore.onNext(groceryShoppings)
        return Observable.just(shopping)
    }
    
    func fetchGroceries(completion: @escaping (([GroceryShopping]) -> Void)) {
        groceryRepository.fetchGroceryInfo { [unowned self] models in
            let groceryShoppings = models.map { shoppingModel -> GroceryShopping in
                
                let id = shoppingModel.id
                let date = Date(timeIntervalSince1970: TimeInterval(shoppingModel.date))
                let totalPrice = shoppingModel.totalPrice
                
                return GroceryShopping(id: id, date: date, totalPrice: totalPrice)
            }
            self.groceryShoppings = groceryShoppings
            completion(groceryShoppings)
            self.shoppingStore.onNext(groceryShoppings)
        }
    }
    
    func fetchShoppingTotalSpend(shoppings: [GroceryShopping]) -> Int {
        let shoppingSpends = shoppings.map { $0.totalPrice }.reduce(0, +)
        return shoppingSpends
    }

}
