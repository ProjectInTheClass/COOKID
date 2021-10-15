//
//  ShoppingService.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation
import RxSwift

class ShoppingService {
   
    private var groceryShoppings: [GroceryShopping] = []
    
    private lazy var shoppingStore = BehaviorSubject<[GroceryShopping]>(value: groceryShoppings)
    
    var initialShoppingCount: Int {
        return groceryShoppings.count
    }
    
    @discardableResult
    func create(shopping: GroceryShopping, completion: @escaping (Bool) -> Void) -> Observable<GroceryShopping> {
        RealmShoppingRepo.instance.createShopping(shopping: shopping)
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
        RealmShoppingRepo.instance.updateShopping(shopping: updateShopping)
        if let index = groceryShoppings.firstIndex(where: { $0.id == updateShopping.id }) {
            groceryShoppings.remove(at: index)
            groceryShoppings.insert(updateShopping, at: index)
        }
        shoppingStore.onNext(groceryShoppings)
        completion(true)
        return Observable.just(updateShopping)
    }
    
    func deleteShopping(shopping: GroceryShopping) {
        RealmShoppingRepo.instance.deleteShopping(shopping: shopping)
        if let index = groceryShoppings.firstIndex(where: { $0.id == shopping.id }) {
            groceryShoppings.remove(at: index)
        }
        shoppingStore.onNext(groceryShoppings)
    }
    
    func fetchShoppings() {
        guard let shoppings = RealmShoppingRepo.instance.fetchShoppings() else { return }
            let groceryShoppings = shoppings.map { shoppingModel -> GroceryShopping in
                return GroceryShopping(id: shoppingModel.id, date: shoppingModel.date, totalPrice: shoppingModel.price)
            }
            self.groceryShoppings = groceryShoppings
            self.shoppingStore.onNext(groceryShoppings)
    }
    
    func spotMonthShoppings(shoppings: [GroceryShopping]) -> [GroceryShopping] {
        let startDay = Date().startOfMonth
        let endDay = Date().endOfMonth
        let filteredByStart = shoppings.filter { $0.date > startDay }
        let filteredByEnd = filteredByStart.filter { $0.date < endDay }
        let sortedshoppings = filteredByEnd.sorted { $0.date > $1.date }
        return sortedshoppings
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
    
    func validationNum(text: String?) -> Bool {
        guard let text = text else { return false }
        if text.isEmpty {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }

}
