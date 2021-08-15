//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class UserRepository {
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    let authRepo = AuthRepository.shared
    
    func fetchUserInfo(completion: @escaping (UserEntity) -> Void) {
        
        if let currentUserUID = Auth.auth().currentUser?.uid {
            let ref = self.db.child(currentUserUID).child(FBChild.user)
            ref.observeSingleEvent(of: .value) { snapshot in
                
                let snapshot = snapshot.value as? [String:Any] ?? [:]
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserEntity.self, from: data)
                    completion(user)
                } catch {
                    print("Cannot fetch UserInfo: \(error.localizedDescription)")
                }
            }
        } else {
            let userDic: [String:Any] = [
                "nickname": "비회원님",
                "determination" : "정보 기입 후에 이용해주세요.",
                "priceGoal" : "0",
                "userType" : "외식러",
                "userId" : "emrgnionergm"
            ]
            completion(UserEntity(userDic: userDic))
        }
    }
    
    
    func uploadUserInfo(userInfo: User) {
        AuthRepository.shared.signInAnonymously { uid in
            let userDic: [String:Any] = [
                "nickname": userInfo.nickname,
                "determination" : userInfo.determination,
                "priceGoal" : userInfo.priceGoal,
                "userType" : userInfo.userType.rawValue,
                "userId" : uid
            ]
            
            self.db.child(uid).child(FBChild.user).setValue(userDic)
        }
        
    }
    
    
    func updateUserInfo(user: User) {
        
        let userDic: [String:Any] = [
            "nickname": user.nickname,
            "determination" : user.determination,
            "priceGoal" : user.priceGoal,
            "userType" : user.userType.rawValue,
            "userId" : user.userID
        ]
        
        self.db.child(user.userID).child(FBChild.user).updateChildValues(userDic)
        
    }
    
    
    func fetchUsers(completion: @escaping (([UserAllEntity]) -> Void)) {
        
        var allUsers: [UserAllEntity] = []
        
        db.observeSingleEvent(of: .value) { snapshot in
            
            let values = snapshot.value as? [String:Any] ?? [:]
            for data in values {
                let values = data.value as? [String:Any] ?? [:]
                var groceries = [GroceryEntity]()
                var meals = [MealEntity]()
                var person: UserEntity?
                for data in values {
                    if data.key == "meal" {
                        let snapshotValue = data.value as? [String:Any] ?? [:]
                        for value in snapshotValue.values {
                            let dic = value as! [String:Any]
                            let meal = MealEntity(mealDic: dic)
                            meals.append(meal)
                        }
                    }else if data.key == "groceries" {
                        let snapshotValue = data.value as? [String:Any] ?? [:]
                        for value in snapshotValue.values {
                            let dic = value as! [String:Any]
                            let meal = GroceryEntity(groceriesDic: dic)
                            groceries.append(meal)
                        }
                    }else {
                        let snapshotValue = data.value as? [String:Any] ?? [:]
                        person = UserEntity(userDic: snapshotValue)
                    }
                }
                allUsers.append(UserAllEntity(groceries: groceries, meal: meals, user: person!))
            }
            
            completion(allUsers)
            
        }
    }
}
