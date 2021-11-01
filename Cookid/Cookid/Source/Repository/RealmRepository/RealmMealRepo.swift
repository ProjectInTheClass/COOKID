//
//  RealmMealRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import UIKit
import RealmSwift

protocol RealmMealRepoType {
    func createMeal(meal: Meal, completion: @escaping (Bool) -> Void)
    func fetchMeals() -> [LocalMeal]?
    func updateMeal(meal: Meal, completion: @escaping (Bool) -> Void)
    func deleteMeal(meal: Meal, completion: @escaping (Bool) -> Void)
}


class RealmMealRepo: BaseRepository, RealmMealRepoType {
    
    func fetchMeals() -> [LocalMeal]? {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        do {
            let realm = try Realm()
            let localMeals = realm.objects(LocalMeal.self)
            return Array(localMeals)
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func createMeal(meal: Meal, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let localMeal = LocalMeal(id: meal.id, price: meal.price, date: meal.date, name: meal.name, mealType: meal.mealType.rawValue, mealTime: meal.mealTime.rawValue)
            try realm.write {
                realm.add(localMeal)
                completion(true)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func deleteMeal(meal: Meal, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let deleteMeal = realm.objects(LocalMeal.self).filter(NSPredicate(format: "id = %@", meal.id)).first {
                try realm.write {
                    realm.delete(deleteMeal)
                    completion(true)
                }
            } else {
                print("meal이 없습니다!")
                completion(false)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func updateMeal(meal: Meal, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            if let updateMeal = realm.objects(LocalMeal.self).filter(NSPredicate(format: "id = %@", meal.id)).first {
                try realm.write {
                    updateMeal.date = meal.date
                    updateMeal.name = meal.name
                    updateMeal.mealTime = meal.mealTime.rawValue
                    updateMeal.mealType = meal.mealType.rawValue
                    updateMeal.price = meal.price
                    completion(true)
                }
            } else {
                print("meal이 없습니다!")
                completion(false)
            }
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
}
