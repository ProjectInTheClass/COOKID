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
            
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "ko")
            let datecompoenets = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: datecompoenets)!
            let date = Int(startOfMonth.timeIntervalSince1970)
            
            var monthFilterQuery: DatabaseQuery?
            
            monthFilterQuery = self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).queryOrdered(byChild: "date").queryStarting(atValue: date)
           
            monthFilterQuery?.observeSingleEvent(of: .value) { snapshot in
                
                let snapshotValue = snapshot.value as? [String:Any] ?? [:]
                let uidKey = snapshotValue.keys
                var mealEntity = [MealEntity]()
                
                for value in snapshotValue.values {
                    let dic = value as! [String:Any]
                    let meal = MealEntity(mealDic: dic)
                    mealEntity.append(meal)
                }
                completion(mealEntity)
                print("uid key --> \(uidKey)")
            }
        }
    }
    
    
    
    func uploadMealToFirebase(meal: Meal) {
        authRepo.signInAnonymously { [weak self] uid in
            let mealDic : [String:Any] = [
                "id" : meal.id,
                "price" : meal.price,
                "date" : meal.date.dateToString(),
                "image" : meal.image?.absoluteString,
                "name" : meal.name,
                "mealType" : meal.mealType.rawValue,
                "mealTime" : meal.mealTime.rawValue
            ]
            
            self?.db.child(uid).child(FBChild.meal).childByAutoId().setValue(mealDic)
        }
    }
    
    
    
    
    func fetchingImageURL(uid: String, mealID: String, image: UIImage, completed: @escaping (URL?) -> Void) {
        let storageRef = storage.child(uid + mealID + ".jpg")
        let data = image.jpegData(compressionQuality: 0.8)
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image.jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error while uploading file : \(error.localizedDescription)")
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error while downloading file : \(error.localizedDescription)")
                        return
                    }
                    if let url = url {
                        completed(url)
                    }
                }
            }
        }
    }
}
