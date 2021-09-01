//
//  ShoppingService.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation
import RxSwift

class ShoppingService {
    
    let groceryRepository: GroceryRepository
    
    private var groceryShoppings: [GroceryShopping] = []
    
    private lazy var shoppingStore = BehaviorSubject<[GroceryShopping]>(value: groceryShoppings)
    
    init(groceryRepository: GroceryRepository) {
        self.groceryRepository = groceryRepository
    }
    
    @discardableResult
    func create(shopping: GroceryShopping, completion: @escaping (Bool) -> Void) -> Observable<GroceryShopping> {
        
        DispatchQueue.global().async {
            self.groceryRepository.uploadGroceryInfo(grocery: shopping)
        }
        
        groceryShoppings.append(shopping)
        shoppingStore.onNext(groceryShoppings)
        completion(true)
        return Observable.just(shopping)
    }
    
    @discardableResult
    func shoppingList() -> Observable<[GroceryShopping]> {
        return shoppingStore
    }
    
    @discardableResult
    func update(updateShopping: GroceryShopping, completion: @escaping (Bool) -> Void) -> Observable<GroceryShopping> {
        
        DispatchQueue.global().async {
            self.groceryRepository.uploadGroceryInfo(grocery: updateShopping)
        }
    
        if let index = groceryShoppings.firstIndex(where: { $0.id == updateShopping.id }) {
            groceryShoppings.remove(at: index)
            groceryShoppings.insert(updateShopping, at: index)
        }
        
        shoppingStore.onNext(groceryShoppings)
        completion(true)
        return Observable.just(updateShopping)
    }
    
    func delete(shoppingID: String) {
        DispatchQueue.global().async {
            self.groceryRepository.deleteGroceryInfo(shoppingID: shoppingID)
        }
        if let index = groceryShoppings.firstIndex(where: { $0.id == shoppingID }) {
            groceryShoppings.remove(at: index)
        }
        shoppingStore.onNext(groceryShoppings)
    }
    
    func fetchShoppings(user: User, completion: @escaping (([GroceryShopping]) -> Void)) {
        groceryRepository.fetchGroceryInfo(user: user) { [unowned self] models in
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
    
    func fetchShoppingByDay(_ day: Date, shoppings: [GroceryShopping]) -> [GroceryShopping] {
        let dayShoppings = shoppings.filter { $0.date.dateToString() == day.dateToString() }
        return dayShoppings
    }
    
    func fetchShoppingTotalSpend(shoppings: [GroceryShopping]) -> Int {
        let shoppingSpends = shoppings.map { $0.totalPrice }.reduce(0, +)
        return shoppingSpends
    }
    
    func todayShoppings(shoppings: [GroceryShopping]) -> [GroceryShopping] {
        return shoppings.filter { $0.date.dateToString() == Date().dateToString() }
    }
    
    private let charSet: CharacterSet = {
        var cs = CharacterSet(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNum(text: String) -> Bool {
        if text.isEmpty {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }

}
