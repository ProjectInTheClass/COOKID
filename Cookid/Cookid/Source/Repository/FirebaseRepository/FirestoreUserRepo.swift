//
//  FirestoreUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias UserResult = (Result<UserEntity?, FirebaseError>) -> Void
typealias RankersResult = (Result<[UserEntity], FirebaseError>) -> Void

protocol UserRepoType {
    func createUser(user: User, completion: @escaping FirebaseResult)
    func updateUser(user: User, completion: @escaping FirebaseResult)
    func fetchUser(userID: String, completion: @escaping UserResult)
    func fetchCookidsRankers(completion: @escaping RankersResult)
    func transactionCookidsCount(userID: String, isAdd: Bool)
    func transactionUserImageURL(userID: String, imageURL: String, completion: @escaping (Bool) -> Void)
}

class FirestoreUserRepo: BaseRepository, UserRepoType {
    
    private let userDB = Firestore.firestore().collection("user")
    
    func createUser(user: User, completion: @escaping FirebaseResult) {
        do {
            try userDB.document(user.id).setData(from: convertUserToEntity(user)) { error in
                if let error = error {
                    print("Error writing user to Firestore: \(error)")
                    completion(.failure(.createUserError))
                } else {
                    completion(.success(.createUserSuccess))
                }
            }
        } catch let error {
            print("Error writing user to Firestore: \(error)")
            completion(.failure(.createUserError))
        }
    }
    
    func updateUser(user: User, completion: @escaping FirebaseResult) {
        userDB.document(user.id).getDocument { document, _ in
            if let document = document, document.exists {
                document.reference.updateData([
                    "priceGoal": user.priceGoal,
                    "userType" : user.userType.rawValue,
                    "nickname" : user.nickname,
                    "determination" : user.determination
                ]) { error in
                    if let error = error {
                        print("Error updating user to Firestore: \(error)")
                        completion(.failure(.updateUserError))
                    } else {
                        completion(.success(.updateUserSuceess))
                    }
                }
            } else {
                print("Error updating user to Firestore")
                completion(.failure(.updateUserError))
            }
        }
    }
    
    /// fetch specific user information
    func fetchUser(userID: String, completion: @escaping UserResult) {
        // 유저ID 쿼리에 일치하는 유저를 DB에서 불러온다.
        userDB.document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user to Firestore: \(error)")
                completion(.failure(.fetchUserError))
            } else if let document = document {
                do {
                    guard let userEntity = try document.data(as: UserEntity.self) else {
                        completion(.failure(.fetchUserError))
                        return
                    }
                    completion(.success(userEntity))
                } catch let error {
                    print("Error fetching user to Firestore: \(error)")
                    completion(.failure(.fetchUserError))
                }
            } else {
                completion(.failure(.fetchUserError))
            }
        }
    }
    
    func transactionUserImageURL(userID: String, imageURL: String, completion: @escaping (Bool) -> Void) {
        userDB.document(userID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(self.userDB.document(userID))
                guard var userEntity = try userDocument.data(as: UserEntity.self) else { return nil }
                userEntity.imageURL = imageURL
                transaction.updateData([
                    "imageURL": userEntity.imageURL
                ], forDocument: self.userDB.document(userID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Error transactionUserImageURL to Firestore: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func transactionCookidsCount(userID: String, isAdd: Bool) {
        userDB.document(userID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(self.userDB.document(userID))
                guard var userEntity = try userDocument.data(as: UserEntity.self) else { return nil }
                if isAdd {
                    userEntity.cookidsCount += 1
                } else {
                    userEntity.cookidsCount -= 1
                }
                transaction.updateData([
                    "cookidsCount": userEntity.cookidsCount
                ], forDocument: self.userDB.document(userID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, _ in }
    }
    
    func fetchCookidsRankers(completion: @escaping RankersResult) {
        // 최소 1개 이상
        userDB
            .order(by: "cookidsCount", descending: true).limit(to: 30)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching rankers to Firestore: \(error)")
                completion(.failure(.fetchRankerError))
            } else if let querySnapshot = querySnapshot {
                do {
                    let userEntity = try querySnapshot.documents.compactMap { try $0.data(as: UserEntity.self) }
                    completion(.success(userEntity))
                } catch let error {
                    print("Error fetching rankers to Firestore: \(error)")
                    completion(.failure(.fetchRankerError))
                }
            }
        }
    }
}
