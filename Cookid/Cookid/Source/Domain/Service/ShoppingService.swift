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
    var shoppingStore: BehaviorSubject<[Shopping]> { get }
    func create(shopping: Shopping, currentUser: User) -> Observable<Bool>
    func fetchShoppings()
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
    lazy var shoppingStore = BehaviorSubject<[Shopping]>(value: shoppings)
    
    // MARK: - Shopping CRUD
    
    var initialShoppingCount: Int {
        return shoppings.count
    }
    
    func create(shopping: Shopping, currentUser: User) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.realmShoppingRepo.createShopping(shopping: shopping) { success in
                if success {
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: true)
                    self.shoppings.append(shopping)
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchShoppings() {
        guard let localShoppings = self.realmShoppingRepo.fetchShoppings() else { return }
        let shoppings = localShoppings.map { $0.toDomain() }
        self.shoppings = shoppings
        self.shoppingStore.onNext(self.shoppings)
    }
    
    func update(updateShopping: Shopping) -> Observable<Bool> {
        return Observable.create { observer in
            self.realmShoppingRepo.updateShopping(shopping: updateShopping) { success in
                if success {
                    if let index = self.shoppings.firstIndex(where: { $0.id == updateShopping.id }) {
                        self.shoppings.remove(at: index)
                        self.shoppings.insert(updateShopping, at: index)
                    }
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteShopping(deleteShopping: Shopping, currentUser: User) -> Observable<Bool> {
        return Observable.create { observer in
            self.realmShoppingRepo.deleteShopping(shopping: deleteShopping) { success in
                if success {
                    if let index = self.shoppings.firstIndex(where: { $0.id == deleteShopping.id }) {
                        self.shoppings.remove(at: index)
                    }
                    self.firestoreUserRepo.transactionCookidsCount(userID: currentUser.id, isAdd: false)
                    self.shoppingStore.onNext(self.shoppings)
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
