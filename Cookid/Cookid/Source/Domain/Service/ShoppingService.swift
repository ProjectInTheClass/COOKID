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
    func create(shopping: Shopping, currentUser: User) -> Observable<Bool>
    func fetchShoppings() -> Observable<[Shopping]>
    func update(updateShopping: Shopping) -> Observable<Bool>
    func deleteShopping(deleteShopping: Shopping, currentUser: User) -> Observable<Bool>
}

class ShoppingService: ShoppingServiceType {
    
    let realmShoppingRepo: RealmShoppingRepoType
    let firestoreUserRepo: UserRepoType
    
    init(realmShoppingRepo: RealmShoppingRepoType,
         firestoreUserRepo: UserRepoType) {
        self.realmShoppingRepo = realmShoppingRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    // MARK: - Shopping Storage
    
    private var shoppings: [Shopping] = []
    private lazy var shoppingStore = BehaviorSubject<[Shopping]>(value: shoppings)
    
    var initialShoppingCount: Int {
        return shoppings.count
    }
    
    var shoppingList: Observable<[Shopping]> {
        return shoppingStore
    }
    
    // MARK: - Shopping CRUD
    func create(shopping: Shopping, currentUser: User) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.realmShoppingRepo.createShopping(shopping: shopping) { success in
                if success {
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: true)
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
    
    func fetchShoppings() -> Observable<[Shopping]> {
        return Observable.create { observer in
            guard let localShoppings = self.realmShoppingRepo.fetchShoppings() else {
                return Disposables.create()
            }
            let shoppings = localShoppings.map { $0.toDomain() }
            observer.onNext(shoppings)
            self.shoppings = shoppings
            self.shoppingStore.onNext(self.shoppings)
            return Disposables.create()
        }
    }
    
    func update(updateShopping: Shopping) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.realmShoppingRepo.updateShopping(shopping: updateShopping) { success in
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
    
    func deleteShopping(deleteShopping: Shopping, currentUser: User) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.realmShoppingRepo.deleteShopping(shopping: deleteShopping) { success in
                if success {
                    if let index = self.shoppings.firstIndex(where: { $0.id == deleteShopping.id }) {
                        self.shoppings.remove(at: index)
                    }
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: false)
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
}
