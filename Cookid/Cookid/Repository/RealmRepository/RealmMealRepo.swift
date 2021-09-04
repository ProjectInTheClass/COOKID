//
//  RealmMealRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import UIKit
import RealmSwift

class RealmMealRepo {
    static let instance = RealmMealRepo()
    
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
    
    func createMeal(meal: Meal) {
        do {
            let realm = try Realm()
            let localMeal = LocalMeal(id: meal.id, price: meal.price, date: meal.date, name: meal.name, mealType: meal.mealType.rawValue, mealTime: meal.mealTime.rawValue)
            try realm.write {
                realm.add(localMeal)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteMeal(meal: Meal) {
        do {
            let realm = try Realm()
            if let deleteMeal = realm.objects(LocalMeal.self).filter(NSPredicate(format: "id = %@", meal.id)).first {
                try realm.write {
                    realm.delete(deleteMeal)
                }
            } else {
                print("meal이 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateMeal(meal: Meal) {
        do {
            let realm = try Realm()
            if let updateMeal = realm.objects(LocalMeal.self).filter(NSPredicate(format: "id = %@", meal.id)).first {
                try realm.write {
                    updateMeal.date = meal.date
                    updateMeal.name = meal.name
                    updateMeal.mealTime = meal.mealTime.rawValue
                    updateMeal.mealType = meal.mealType.rawValue
                    updateMeal.price = meal.price
                }
            } else {
                print("meal이 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func saveImage(image: UIImage) -> URL? {
        return nil
    }
    
    func deleteImage(url: URL?) {
        
    }
    
}
