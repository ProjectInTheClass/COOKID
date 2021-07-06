//
//  MealRepository.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MealRepository {
    
    static let shared = MealRepository()
    
    let db = Database.database().reference()
    let storage = Storage.storage().reference()
    
    
    func fetchMeals(comletion: @escaping ([MealEntity]) -> Void) {
        db.child(FBChild.meal).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var meals = [MealEntity]()

            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let mealEntity = try decoder.decode(MealEntity.self, from: data)
                meals.append(mealEntity)
                comletion(meals)
            } catch {
                print("Error -> \(error.localizedDescription)")
            }
        }
    }
    
    
    func converToMeal(completion: @escaping (Meal) -> Void) {
        MealRepository.shared.fetchMeals { mealEntity in
            var meals: Meal!
            for mealEntity in mealEntity {
                let meal = Meal(price: mealEntity.price,
                                date: mealEntity.date.StringTodate()!,
                                name: mealEntity.name,
                                image: nil,
                                mealType: MealType(rawValue: mealEntity.mealType) ?? .dineIn,
                                mealTime: MealTime(rawValue: mealEntity.mealTime) ?? .breakfast)
                meals = meal
            }
            completion(meals)
        }
    }
    
    
    func uploadMeal() {
        let mySingleMeal = DummyData.shared.mySingleMeal
        
        db.child(FBChild.meal).setValue(mySingleMeal.converToDic)
        
        guard let image = mySingleMeal.image else { return }
        self.uploadMealImage(mealID: mySingleMeal.id, image: image)
    }
    
    
    func uploadMealImage(mealID: String, image: UIImage) {
        let storageRef = storage.child(mealID + ".jpg")
        let data = image.jpegData(compressionQuality: 0.8)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image.jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { metadata, error in
                
                if let error = error {
                    print("Error while uploading file : \(error.localizedDescription)")
                }
                
                if let metadata = metadata {
                    print("Metadata : \(metadata)")
                }
            }
        }
    }
}
