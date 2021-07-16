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
    
    let authRepo = AuthRepository()
    
    lazy var ref = db.child(authRepo.uid).child(FBChild.user)
    
    func fetchUserInfo(completion: @escaping (UserEntity) -> Void) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            
            let ref = self.db.child(uid).child(FBChild.user)
            
            ref.observeSingleEvent(of: .value) { snapshot in
                
                let dummyUserDic: [String:Any] = [
                    "nickname": "비회원",
                    "determination" : "유저 정보 등록 후에 사용해 주세요.",
                    "priceGoal" : "0",
                    "userType" : "외식러",
                    "userId" : "thisisdefalutuidfornil"
                ]
                
                let snapshot = snapshot.value as? [String:Any] ?? dummyUserDic
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserEntity.self, from: data)
                    completion(user)
                } catch {
                    print("Cannot fetch UserInfo: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    func uploadUserInfo(userInfo: User) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            let userDic: [String:Any] = [
                "nickname": userInfo.nickname,
                "determination" : userInfo.determination,
                "priceGoal" : userInfo.priceGoal,
                "userType" : userInfo.userType.rawValue,
                "userId" : uid
            ]
            let reference = self.db.child(uid).child(FBChild.user)
            reference.setValue(userDic)
        }
    }
    
    
    func updateUserInfo(user: User) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            let userDic: [String:Any] = [
                "nickname": user.nickname,
                "determination" : user.determination,
                "priceGoal" : user.priceGoal,
                "userType" : user.userType.rawValue,
                "userId" : uid
            ]
            let reference = self.db.child(user.userID).child(FBChild.user)
            reference.updateChildValues(userDic)
        }
    }
    
    func deleteUser(){
        
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { error in
            if let error = error {
                print("유저 삭제 오류\(error)")
            }
        })
    }
    
    
}

