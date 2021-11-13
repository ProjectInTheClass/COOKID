//
//  FirestoreCommentRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
//import Firebase

protocol CommentRepoType {
    func createComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func fetchComments(postID: String, completion: @escaping (Result<[CommentEntity], FirebaseError>) -> Void)
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void)
    func deleteComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func reportComment(comment: Comment, user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
}

class FirestoreCommentRepo: BaseRepository, CommentRepoType {
    
    //    private let commentDB = Firestore.firestore().collection("comment")
    
    var commentDB = [CommentEntity]()
    
    func createComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        
    }
    
    func deleteComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        
    }
    
    func reportComment(comment: Comment, user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        
    }
    
    func fetchComments(postID: String, completion: @escaping (Result<[CommentEntity], FirebaseError>) -> Void) {
        
    }
    
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void) {
        
    }
}
