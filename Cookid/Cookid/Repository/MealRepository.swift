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
    let authRepo = AuthRepository()
    
    
    func fetchMeals(completion: @escaping ([MealEntity]) -> Void) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
           
            self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).observeSingleEvent(of: .value) { snapshot in
                
                let snapshotValue = snapshot.value as? [String:Any] ?? [:]
                var mealEntity = [MealEntity]()
                
                for value in snapshotValue.values {
                    let dic = value as! [String:Any]
                    let meal = MealEntity(mealDic: dic)
                    mealEntity.append(meal)
                }
                completion(mealEntity)
            }
        }
    }
    
    func fetchImage(mealName: String, completion: @escaping (URL) -> Void) {
        
        let storageRef = storage.child(mealName + ".jpg")
        
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
    
    
    func pushMealToFirebase(meal: Meal) {
        authRepo.signInAnonymously { [weak self] uid in
            let mealDic : [String:Any] = [
                "id" : uid,
                "price" : meal.price,
                "date" : meal.date.dateToString(),
                "name" : meal.name,
                "mealType" : meal.mealType.rawValue,
                "mealTime" : meal.mealTime.rawValue
            ]
            
            self?.db.child(uid).child(FBChild.meal).childByAutoId().setValue(mealDic)
        }
        
    }
    
    
    
    
    func uploadMealImage(mealName: String, image: UIImage) {
        let storageRef = storage.child(mealName + ".jpg")
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
