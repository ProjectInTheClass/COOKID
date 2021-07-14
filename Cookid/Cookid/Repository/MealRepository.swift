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
    
    lazy var ref = db.child(authRepo.uid).child(FBChild.meal)
    
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
                //let uidKey = snapshotValue.keys
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
    
    
    
    func uploadMealToFirebase(meal: Meal) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let key = self?.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).childByAutoId().key else { return }
            let mealDic : [String:Any] = [
                "id" : key,
                "price" : meal.price,
                "date" : meal.date.dateToInt(),
                "image" : meal.image?.absoluteString as Any,
                "name" : meal.name,
                "mealType" : meal.mealType.rawValue,
                "mealTime" : meal.mealTime.rawValue
            ]
            self?.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).child(key).setValue(mealDic)
        }
    }
    
    
    
    func updateMealToFirebase(meal: Meal) {
        authRepo.signInAnonymously { [weak self] uid in
            let mealDic : [String:Any] = [
                "id" : meal.id as Any,
                "price" : meal.price,
                "date" : meal.date.dateToInt(),
                "image" : meal.image?.absoluteString as Any,
                "name" : meal.name,
                "mealType" : meal.mealType.rawValue,
                "mealTime" : meal.mealTime.rawValue
            ]
            self?.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).child(meal.id!).updateChildValues(mealDic)
        }
    }
    
    
    
    func deleteMealToFirebase(meal: Meal) {
        authRepo.signInAnonymously { [weak self] uid in
            self?.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.meal).child(meal.id!).removeValue()
        }
    }
    
    
    
    func fetchingImageURL(mealID: String, image: UIImage, completed: @escaping (URL?) -> Void) {
        let storageRef = storage.child(mealID + ".jpg")
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
