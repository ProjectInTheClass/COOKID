//
//  FirestoreCommentRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommentRepoType {
    func createComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func fetchComments(postID: String, completion: @escaping (Result<[CommentEntity], FirebaseError>) -> Void)
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void)
    func deleteComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
    func reportComment(comment: Comment, user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void)
}

class FirestoreCommentRepo: BaseRepository, CommentRepoType {
    
    private let commentDB = Firestore.firestore().collection("comment")
   
    func createComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        do {
            try commentDB.document(comment.commentID).setData(from: convertCommentToEntity(comment), merge: false) { error in
                if let error = error {
                    completion(.failure(.commentCreateError))
                    print("cannot create comment \(error)")
                } else {
                    completion(.success(.createCommentSuccess))
                }
            }
        } catch {
            completion(.failure(.commentCreateError))
        }
    }
    
    func deleteComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        commentDB.document(comment.commentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(.failure(.commentDeleteError))
            } else {
                print("Document successfully removed!")
                completion(.success(.deleteCommentSuccess))
            }
        }
    }
    
    func reportComment(comment: Comment, user: User, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        
    }
    
    func fetchComments(postID: String, completion: @escaping (Result<[CommentEntity], FirebaseError>) -> Void) {
        
    }
    
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void) {
        
    }
}
