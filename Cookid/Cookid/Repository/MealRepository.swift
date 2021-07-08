//
//  MealRepository.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class MealRepository {
    
    static let shared = MealRepository()
    
    let db = Database.database().reference()
    let storage = Storage.storage().reference()
    let uid = UserRepository.shared.uid
    
    
    func fetchMeals(completion: @escaping ([MealEntity]) -> Void) {
        db.child(uid).child(FBChild.meal).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var meals = [MealEntity]()
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let mealEntity = try decoder.decode(MealEntity.self, from: data)
                meals.append(mealEntity)
                completion(meals)
            } catch {
                print("Error -> \(error.localizedDescription)")
            }
        }
    }
    
    
    func fetchImage(mealID: String, completion: @escaping (URL) -> Void) {
        
        let storageRef = storage.child(mealID + ".jpg")
        
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error while downloading file : \(error.localizedDescription)")
                return
            }
            if let url = url {
                completion(url)
                print(url)
            }
        }
    }
    
    
    func pushMealToFirebase(uid: String, isAnonymous: Bool, meal: Meal) {
        
        let mealDic : [String:Any] = [
            "id" : uid,
            "price" : meal.price,
            "date" : meal.date.dateToString(),
            "name" : meal.name,
            "image" : meal.image,
            "mealType" : meal.mealType.rawValue,
            "mealTime" : meal.mealTime.rawValue
        ]
        
        db.child(uid).child(FBChild.meal).childByAutoId().setValue(mealDic)
        
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
