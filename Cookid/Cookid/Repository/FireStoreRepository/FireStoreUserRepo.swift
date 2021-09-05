//
//  FireStoreUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FireStoreUserRepo {
    static let instance = FireStoreUserRepo()
    
    private let userDB = Firestore.firestore().collection("user")
    
    func createUser(user: User, completion: @escaping (Bool) -> Void) {
        do {
            try userDB.document(user.id).setData(from: user)
            completion(true)
        } catch {
            print("Error writing user to Firestore: \(error)")
            completion(false)
        }
    }
    
    func fetchUser(user: User, completion: @escaping (User?) -> Void) {
        userDB.document(user.id).getDocument(source: .default) { (document, error) in
            
            let result = Result {
                try document?.data(as: User.self)
            }
            
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user)
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
                completion(nil)
            }
        }
    }
        
    func updateUser(updateUser: User, completion: @escaping (Bool) -> Void) {
        do {
            try userDB.document(updateUser.id).setData(from: updateUser, merge: true)
            completion(true)
        } catch {
            print("Error writing user to Firestore: \(error)")
            completion(false)
        }
    }
    
    func fetchDineInRankers() {
        
    }
    
    func fetchCookidsRankers() {
        
    }
}
