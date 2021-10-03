//
//  FirestoreUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import UIKit
//import Firebase
//import FirebaseFirestore
//import FirebaseStorage

class FirestoreUserRepo {
    static let instance = FirestoreUserRepo()
    
//    private let userDB = Firestore.firestore().collection("user")
//    private let userStorage = Storage.storage().reference().child("user")
    
    func createUser(user: User, completion: @escaping (Bool) -> Void) {
//        FirebaseStorageRepo.instance.uploadUserImage(userID: user.id, image: user.image) { url in
//            let userEntity = UserEntity(id: user.id, imageURL: url, nickname: user.nickname, determination: user.determination, priceGoal: user.priceGoal, userType: user.userType, dineInCount: user.dineInCount, cookidsCount: user.cookidsCount)
//            do {
//                print("upload \(userEntity)")
////                try self.userDB.document(user.id).setdate
//                completion(true)
//            } catch {
//                print("Error writing user to Firestore: \(error)")
//                completion(false)
//            }
//        }
    }
    
    func fetchUser(userID: String, completion: @escaping (UserEntity?) -> Void) {
        //        userDB.document(userID).getDocument(source: .default) { (document, error) in
        //
        //            let result = Result {
        //                try document?.data(as: User.self)
        //            }
        //
        //            switch result {
        //            case .success(let user):
        //                if let user = user {
        //                    completion(user)
        //                } else {
        //                    print("Document does not exist")
        //                    completion(nil)
        //                }
        //            case .failure(let error):
        //                print("Error decoding city: \(error)")
        //                completion(nil)
        //            }
        //        }
    }
    
    func updateUser(updateUser: User) {
//        do {
//            try userDB.document(updateUser.id).setData(from: updateUser, merge: true)
//        } catch {
//            print("Error writing user to Firestore: \(error)")
//        }
    }
    
    func fetchDineInRankers() {
        
    }
    
    func fetchCookidsRankers() {
        
    }
}
