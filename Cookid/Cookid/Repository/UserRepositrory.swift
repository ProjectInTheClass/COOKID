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
    
    var uid: String = ""
    var isAnonymous: Bool = false
    

    func fetchUserInfo(completion: @escaping ([UserEntity]) -> Void) {
        
        let ref = db.child(FBChild.user)
        
        ref.queryOrdered(byChild: "userId").observeSingleEvent(of: .value) { snapshot in
            
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
    
    
    
    func uploadUserInfo(userInfo: User) {
        let uid = self.uid
        let userDic: [String:Any] = [
            "userId" : uid,
            "nickname": userInfo.nickname,
            "determination" : userInfo.determination,
            "priceGoal" : userInfo.priceGoal,
            "userType" : userInfo.userType.rawValue
        ]
        let reference = db.child(FBChild.user)
        reference.setValue(userDic)
    }
    
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { [weak self] authdata, error in
            guard let self = self else { return }
            if error != nil {
                print(error?.localizedDescription)
                return
            } else {
                guard let user = authdata?.user else { return }
                self.uid = user.uid
                self.isAnonymous = user.isAnonymous
            }
            print(self.uid)
        }
    }
}

