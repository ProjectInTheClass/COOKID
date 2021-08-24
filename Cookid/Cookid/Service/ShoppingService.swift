//
//  ShoppingService.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation
import RxSwift

class ShoppingService {
    
    var currentDay = Date()
    
    let groceryRepository: GroceryRepository
    
    private var groceryShoppings: [GroceryShopping] = []
    
    private lazy var shoppingStore = BehaviorSubject<[GroceryShopping]>(value: groceryShoppings)
    
    init(groceryRepository: GroceryRepository) {
        self.groceryRepository = groceryRepository
    }
    
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
        
         groceryRepository.deleteGroceryInfo(grocery: shopping)
        
        if let index = groceryShoppings.firstIndex(where: { $0.id == shopping.id }) {
            groceryShoppings.remove(at: index)
        }
        
        shoppingStore.onNext(groceryShoppings)
        return Observable.just(shopping)
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
    
    func fetchShoppingTotalSpend(shoppings: [GroceryShopping]) -> Int {
        let shoppingSpends = shoppings.map { $0.totalPrice }.reduce(0, +)
        return shoppingSpends
    }
    
    func fetchShoppingByNavigate(_ day: Int) -> (String, [GroceryShopping]) {
        guard let aDay = Calendar.current.date(byAdding: .day, value: day, to: currentDay) else { return ("", []) }
        currentDay = aDay
        let dateString = convertDateToString(format: "YYYY년 M월 d일", date: aDay)
        let shopping = self.groceryShoppings.filter {$0.date.dateToString() == aDay.dateToString() }
        
        return (dateString, shopping)
    }
    
    func fetchShoppingByDay(_ day: Date) -> (String, [GroceryShopping]) {
        currentDay = day
        let dateString = convertDateToString(format: "YYYY년 M월 d일", date: day)
        let shopping = self.groceryShoppings.filter { $0.date.dateToString() == day.dateToString() }
        return (dateString, shopping)
    }
    
    func todayShoppings(shoppings: [GroceryShopping]) -> [GroceryShopping] {
        return shoppings.filter { $0.date.dateToString() == Date().dateToString() }
    }

}
