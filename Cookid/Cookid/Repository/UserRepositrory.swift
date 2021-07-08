//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class UserRepository {
    
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    let authRepo = AuthRepository()
    
    
    func fetchUserInfo(completion: @escaping ([UserEntity]) -> Void) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            
            let ref = self.db.child(uid).child(FBChild.user)
            
            ref.observeSingleEvent(of: .value) { snapshot in
                
                let snapshot = snapshot.value as! [String:Any]
                var users = [UserEntity]()
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserEntity.self, from: data)
                    users.append(user)
                    print(users)
                    completion(users)
                } catch {
                    print("Cannot fetch UserInfo: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    func uploadUserInfo(userInfo: User) {
        let uid = authRepo.uid
        let userDic: [String:Any] = [
            "userId" : uid,
            "nickname": userInfo.nickname,
            "determination" : userInfo.determination,
            "priceGoal" : userInfo.priceGoal,
            "userType" : userInfo.userType.rawValue
        ]
        let reference = db.child(uid).child(FBChild.user)
        reference.setValue(userDic)
    }
    
    
    
    
    
//    func pushToFirebase() {
//        let uid = authRepo.uid
//        GroceryRepository.shared.pushGroceryInfo(uid: uid, grocery: DummyData.shared.mySingleShopping)
//        DummyData.shared.myMeals.forEach { meal in MealRepository.shared.pushMealToFirebase(uid: uid, isAnonymous: isAnonymous, meal: meal) }
//        uploadUserInfo(userInfo: DummyData.shared.singleUser)
//
//    }
}

