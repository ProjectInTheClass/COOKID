//
//  RealmShoppingRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

protocol RealmShoppingRepoType {
    func createShopping(shopping: Shopping, completion: @escaping (Bool) -> Void)
    func fetchShoppings() -> [LocalShopping]?
    func updateShopping(shopping: Shopping, completion: @escaping (Bool) -> Void)
    func deleteShopping(shopping: Shopping, completion: @escaping (Bool) -> Void)
}

class RealmShoppingRepo: BaseRepository, RealmShoppingRepoType {
    
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
    
    func createShopping(shopping: Shopping, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let localShopping = LocalShopping(id: shopping.id, date: shopping.date, price: shopping.totalPrice)
            try realm.write {
                realm.add(localShopping)
                completion(true)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func deleteShopping(shopping: Shopping, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let deleteShopping = realm.objects(LocalShopping.self).filter(NSPredicate(format: "id = %@", shopping.id)).first {
                try realm.write {
                    realm.delete(deleteShopping)
                    completion(true)
                }
            } else {
                print("shopping이 없습니다!")
                completion(false)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func updateShopping(shopping: Shopping, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let updateShopping = realm.objects(LocalShopping.self).filter(NSPredicate(format: "id = %@", shopping.id)).first {
                try realm.write {
                    updateShopping.date = shopping.date
                    updateShopping.price = shopping.totalPrice
                    completion(true)
                }
            } else {
                print("shopping이 없습니다!")
                completion(false)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
}
