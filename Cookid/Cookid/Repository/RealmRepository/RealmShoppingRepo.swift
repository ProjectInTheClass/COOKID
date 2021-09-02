//
//  RealmShoppingRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class RealmShoppingRepo {
    static let instance = RealmShoppingRepo()
    
    func fetchShoppings() -> [LocalShopping]? {
        do {
            let realm = try Realm()
            let localShopping = realm.objects(LocalShopping.self)
            return Array(localShopping)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func createShopping(shopping: GroceryShopping) {
        do {
            let realm = try Realm()
            let localShopping = LocalShopping(id: shopping.id, date: shopping.date, price: shopping.totalPrice)
            try realm.write {
                realm.add(localShopping)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteShopping(shopping: GroceryShopping) {
        do {
            let realm = try Realm()
            if let deleteShopping = realm.objects(LocalShopping.self).filter(NSPredicate(format: "id = %@", shopping.id)).first {
                try realm.write {
                    realm.delete(deleteShopping)
                }
            } else {
                print("shopping이 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateShopping(shopping: GroceryShopping) {
        do {
            let realm = try Realm()
            if let updateShopping = realm.objects(LocalShopping.self).filter(NSPredicate(format: "id = %@", shopping.id)).first {
                try realm.write {
                    updateShopping.date = shopping.date
                    updateShopping.price = shopping.totalPrice
                }
            } else {
                print("shopping이 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
}
