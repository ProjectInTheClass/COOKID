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
            var mealEntity = [MealEntity]()
            
            for value in snapshotValue.values {
                let dic = value as? [String:Any] ?? [:]
                let meal = MealEntity(mealDic: dic)
                mealEntity.append(meal)
            }
            completion(mealEntity)
        }
        
    }
    
    func uploadMealToFirebase(meal: Meal) {
    
        guard let currentUserUID = Auth.auth().currentUser?.uid else { print("user nil")
            return }
        
        let mealDic : [String:Any] = [
            "id" : meal.id,
            "price" : meal.price,
            "date" : meal.date.dateToInt(),
            "image" : meal.image?.absoluteString as Any,
            "name" : meal.name,
            "mealType" : meal.mealType.rawValue,
            "mealTime" : meal.mealTime.rawValue
        ]
        self.db.child(currentUserUID).child(FBChild.meal).child(meal.id).setValue(mealDic)

    }
    
    func updateMealToFirebase(meal: Meal) {
        print("updateMealToFirebase")
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
    
    func deleteMealToFirebase(mealID: String) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.db.child(currentUserUID).child(FBChild.meal).child(mealID).removeValue()
    }
    
    func deleteImage(mealID: String?) {
        guard let mealID = mealID else { print("deleteImage userID nil")
            return
        }
        let storageRef = storage.child(mealID + ".jpg")
        
        storageRef.delete { error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                print("delete \(mealID)")
            }
        }
    }
    
    func fetchImageURL(mealID: String?, completion: @escaping (URL) -> Void) {
        print("fetchImage URL")
        guard let mealID = mealID else { print("mealID nil")
            return
        }
        let storageRef = storage.child(mealID + ".jpg")
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Error while downloading file : \(error.localizedDescription)")
            }
            if let url = url {
                completion(url)
            }
        }
    }
    
    func uploadImage(mealID: String?, image: UIImage?, completed: @escaping (Bool) -> Void) {
        print("updloa imgaeeee")
        guard let mealID = mealID else { print("uploadImage userID nil")
            return
        }
        let storageRef = storage.child(mealID + ".jpg")
        let data = image?.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image.jpg"
        if let data = data {
            storageRef.putData(data, metadata: metadata) { _, error in
                if let error = error {
                    print("Error while uploading file : \(error.localizedDescription)")
                }
               
            }
        }
    }
}
