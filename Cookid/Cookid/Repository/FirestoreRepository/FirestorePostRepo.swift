//
//  FirestorePostRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class FirestorePostRepo {
    static let instance = FirestorePostRepo()
    
    func asyncTask(completionHandler: @escaping (String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completionHandler("Hello World !!!")
        }
    }
    
    func createPost(post: Post, completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(.successSignIn))
        }
    }
    
    func updatePost(updatedPost: Post) {
        print(updatedPost.postID)
    }
    
    func fetchPosts(user: User, completion: @escaping ([PostEntity]) -> Void) {
        
    }
    
    func deletePost(deletePost: Post) {
        print(deletePost.postID)
    }
}
