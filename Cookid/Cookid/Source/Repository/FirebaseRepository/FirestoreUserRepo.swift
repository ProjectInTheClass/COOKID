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
    func loadUser(userID: String, completion: @escaping UserResult)
    func fetchUser(userID: String, completion: @escaping UserResult)
    func fetchCookidsRankers(completion: @escaping RankersResult)
    
}

class FirestoreUserRepo: BaseRepository, UserRepoType {
    
    private let userDB = Firestore.firestore().collection("user")
    
    func createUser(user: User, completion: @escaping FirebaseResult) {

    }
    
    func updateUser(user: User, completion: @escaping FirebaseResult) {
        // 업데이트시에 localUser의 정보도 건드린다면 함께 업데이트 해야 한다. service 단계에서 처리
    
    }
    
    /// load current user information
    func loadUser(userID: String, completion: @escaping UserResult) {
        
    }
    
    /// fetch specific user information
    func fetchUser(userID: String, completion: @escaping UserResult) {
        // 유저ID 쿼리에 일치하는 유저를 DB에서 불러온다.
        
    }
    
    func fetchCookidsRankers(completion: @escaping RankersResult) {
        // 최소 1개 이상
        
    }
}
