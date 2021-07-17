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
    
    let db = Database.database().reference()
    let storage = Storage.storage().reference()
    let authRepo = AuthRepository.shared
    
    
    func fetchMeals(user: User, completion: @escaping ([MealEntity]) -> Void) {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")
        let datecompoenets = calendar.dateComponents([.year, .month], from: Date())
        let startOfMonth = calendar.date(from: datecompoenets)!
        let date = Int(startOfMonth.timeIntervalSince1970)
        
        var monthFilterQuery: DatabaseQuery?
        
        monthFilterQuery = self.db.child(user.userID).child(FBChild.meal).queryOrdered(byChild: "date").queryStarting(atValue: date)
        
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
    
    func uploadMealToFirebase(meal: Meal, completed: @escaping (String) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        guard let key = self.db.child(currentUserUID).child(FBChild.meal).childByAutoId().key else { return }
        let mealDic : [String:Any] = [
            "id" : key,
            "price" : meal.price,
            "date" : meal.date.dateToInt(),
            "image" : meal.image?.absoluteString as Any,
            "name" : meal.name,
            "mealType" : meal.mealType.rawValue,
            "mealTime" : meal.mealTime.rawValue
        ]
        self.db.child(currentUserUID).child(FBChild.meal).child(key).setValue(mealDic)
        completed(key)
    }
    
    
    
    func updateMealToFirebase(meal: Meal) {
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        let mealDic : [String:Any] = [
            "id" : meal.id as Any,
            "price" : meal.price,
            "date" : meal.date.dateToInt(),
            "image" : meal.image?.absoluteString as Any,
            "name" : meal.name,
            "mealType" : meal.mealType.rawValue,
            "mealTime" : meal.mealTime.rawValue
        ]
        
        self.db.child(currentUserUID).child(FBChild.meal).child(meal.id).updateChildValues(mealDic)
    }
    
    
    func deleteMealToFirebase(meal: Meal) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.db.child(currentUserUID).child(FBChild.meal).child(meal.id).removeValue()
    }
    
    
    func deleteImage(meal: Meal) {
        let storageRef = storage.child(meal.id! + ".jpg")
        
        storageRef.delete { error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    
    func fetchingImageURL(mealID: String, image: UIImage, completed: @escaping (URL?) -> Void) {
        let storageRef = storage.child(mealID + ".jpg")
        let data = image.jpegData(compressionQuality: 0.1)
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
