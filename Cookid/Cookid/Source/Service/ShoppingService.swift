//
//  ShoppingService.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation
import RxSwift

protocol ShoppingServiceType {
    var initialShoppingCount: Int { get }
    var shoppingList: Observable<[Shopping]> { get }
    func create(shopping: Shopping) -> Observable<Bool>
    func fetchShoppings()
    func update(updateShopping: Shopping) -> Observable<Bool>
    func deleteShopping(deleteShopping: Shopping) -> Observable<Bool>
}

class ShoppingService: BaseService, ShoppingServiceType {
   
    private var shoppings: [Shopping] = []
    
    private lazy var shoppingStore = BehaviorSubject<[Shopping]>(value: shoppings)
    
    var initialShoppingCount: Int {
        return shoppings.count
    }
    
    var shoppingList: Observable<[Shopping]> {
        return shoppingStore
    }
    
    func create(shopping: Shopping) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.realmShoppingRepo.createShopping(shopping: shopping) { success in
                if success {
                    self.shoppings.append(shopping)
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchShoppings() {
        guard let LocalShoppings = self.repoProvider.realmShoppingRepo.fetchShoppings() else { return }
        let shoppings = LocalShoppings.map { localShopping -> Shopping in
            return Shopping(id: localShopping.id, date: localShopping.date, totalPrice: localShopping.price)
        }
        self.shoppings = shoppings
        self.shoppingStore.onNext(self.shoppings)
    }
    
    func update(updateShopping: Shopping) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.realmShoppingRepo.updateShopping(shopping: updateShopping) { success in
                if success {
                    if let index = self.shoppings.firstIndex(where: { $0.id == updateShopping.id }) {
                        self.shoppings.remove(at: index)
                        self.shoppings.insert(updateShopping, at: index)
                    }
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteShopping(deleteShopping: Shopping) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.realmShoppingRepo.deleteShopping(shopping: deleteShopping) { success in
                if success {
                    if let index = self.shoppings.firstIndex(where: { $0.id == deleteShopping.id }) {
                        self.shoppings.remove(at: index)
                    }
                    self.shoppingStore.onNext(self.shoppings)
                } else {
                    
                }
            }
            return Disposables.create()
        }
    }
    
}
