//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation
import FirebaseDatabase


class UserRepository {
    
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    
    func fetchUserInfo(userID: String, completion: @escaping ([UserEntity]) -> Void) {
        db.child(FBChild.user).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var users = [UserEntity]()
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserEntity.self, from: data)
                users.append(user)
                completion(users)
            } catch {
                print("Cannot fetch UserInfo: \(error.localizedDescription)")
            }
        }
    }
    
    
    func uploadUserInfo() {
        let dummyUser = DummyData.shared.user
        db.child(FBChild.user).setValue(dummyUser.convertToDic)
    }
}
