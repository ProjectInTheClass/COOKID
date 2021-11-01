//
//  FirestoreUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import UIKit
//import Firebase
//import FirebaseFirestore

protocol UserRepoType {
    func createUser(user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func loadUser(userID: String, completion: @escaping (Result<UserEntity?, FirebaseError>) -> Void)
    func fetchUser(userID: String, completion: @escaping (Result<UserEntity?, FirebaseError>) -> Void)
    func fetchCookidsRankers(completion: @escaping (Result<[UserEntity], FirebaseError>) -> Void)
    func updateUser(user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
}

class FirestoreUserRepo: BaseRepository, UserRepoType {
    
//    private let userDB = Firestore.firestore().collection("user")
    
    var userDB = [
        UserEntity(id: "", imageURL: URL(string: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80"), nickname: "제이미", determination: "화이팅!", priceGoal: 400000, userType: "집밥러", dineInCount: 12, cookidsCount: 20),
        UserEntity(id: "", imageURL: URL(string: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=688&q=80"), nickname: "세라", determination: "화이팅!", priceGoal: 400000, userType: "집밥러", dineInCount: 14, cookidsCount: 30),
        UserEntity(id: "", imageURL: URL(string: "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"), nickname: "제이콥", determination: "화이팅!", priceGoal: 400000, userType: "집밥러", dineInCount: 15, cookidsCount: 10),
        UserEntity(id: "", imageURL: URL(string: "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"), nickname: "제이콥", determination: "화이팅!", priceGoal: 400000, userType: "집밥러", dineInCount: 18, cookidsCount: 17)
    ]
    
    func createUser(user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
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
    
    /// load current user information
    func loadUser(userID: String, completion: @escaping (Result<UserEntity?, FirebaseError>) -> Void) {
        completion(.success(UserEntity(id: userID,
                                       imageURL: URL(string: "https://images.unsplash.com/photo-1555952517-2e8e729e0b44?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=764&q=80"),
                                       nickname: "Paul",
                                       determination: "I can do it!",
                                       priceGoal: 400000,
                                       userType: "집밥러",
                                       dineInCount: 20,
                                       cookidsCount: 30)))
    }
    
    func fetchUser(userID: String, completion: @escaping (Result<UserEntity?, FirebaseError>) -> Void) {
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
        
        // 유저ID 쿼리에 일치하는 유저를 DB에서 불러온다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success(UserEntity(id: userID, imageURL: URL(string: "https://images.unsplash.com/photo-1504593811423-6dd665756598?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1470&q=80"), nickname: "테스터", determination: "화이또오!", priceGoal: 372920, userType: "집밥러", dineInCount: 40, cookidsCount: 34)))
        }
        
    }
    
    func updateUser(user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        // 유저의 정보 전체를 Entity로 파싱 후에 업로드 한다.
        // 업데이트시에 localUser의 정보도 건드린다면 함께 업데이트 해야 한다.
        
//        do {
//            try userDB.document(updateUser.id).setData(from: updateUser, merge: true)
//        } catch {
//            print("Error writing user to Firestore: \(error)")
//        }
    }
    
    func fetchCookidsRankers(completion: @escaping (Result<[UserEntity], FirebaseError>) -> Void) {
        // 최소 1개 이상
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(.success([]))
        }
    }
}
