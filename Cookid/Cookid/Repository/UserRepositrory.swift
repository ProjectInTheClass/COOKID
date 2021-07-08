//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase


class UserRepository {
    
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    
    func fetchUserInfo(userID: String?, completion: @escaping ([UserEntity]) -> Void) {
        
        let key = db.child(FBChild.user).childByAutoId().key
        
        db.child(FBChild.user).child(key!).observeSingleEvent(of: .value) { snapshot in
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
    
    func uploadUserInfo() {
        let dummyUser = DummyData.shared.singleUser
        db.child(FBChild.user).childByAutoId().setValue(dummyUser.converToDic)
    }
}

