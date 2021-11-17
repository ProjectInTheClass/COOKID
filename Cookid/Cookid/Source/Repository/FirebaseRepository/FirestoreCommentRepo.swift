//
//  FirestoreCommentRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias CommentResult = (Result<[CommentEntity], FirebaseError>) -> Void

protocol CommentRepoType {
    func createComment(comment: Comment, completion: @escaping FirebaseResult)
    func fetchComments(postID: String, completion: @escaping CommentResult)
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void)
    func deleteComment(comment: Comment, completion: @escaping FirebaseResult)
    func reportComment(comment: Comment, user: User, completion: @escaping FirebaseResult)
}

class FirestoreCommentRepo: BaseRepository, CommentRepoType {
    
    private let commentDB = Firestore.firestore().collection("comment")
   
    func createComment(comment: Comment, completion: @escaping FirebaseResult) {
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
    
    func deleteComment(comment: Comment, completion: @escaping FirebaseResult) {
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
    
    func reportComment(comment: Comment, user: User, completion: @escaping FirebaseResult) {
        commentDB.document(comment.commentID).firestore.runTransaction { [weak self] transaction, errorPointer -> Any? in
            guard let self = self else { return nil }
            let commentDocument: DocumentSnapshot
            do {
                try commentDocument = transaction.getDocument(self.commentDB.document(comment.commentID))
                guard var commentEntity = try commentDocument.data(as: CommentEntity.self) else {
                    print("decoding error : firestore data to comment instance")
                    completion(.failure(.commentReportError))
                    return nil }
                
                commentEntity.isReported.append(user.id)
                transaction.updateData([
                    "isReported": commentEntity.isReported
                ], forDocument: self.commentDB.document(comment.commentID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                print("decoding error : firestore data to comment instance")
                completion(.failure(.commentReportError))
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(.failure(.commentReportError))
            } else {
                print("Transaction successfully committed!")
                completion(.success(.reportCommentSuceess))
            }
        }
    }
    
    func fetchComments(postID: String, completion: @escaping CommentResult) {
        commentDB
            .whereField("postID", isEqualTo: postID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.commentFetchError))
                } else if let querySnapshot = querySnapshot {
                    do {
                        let commentEntity = try querySnapshot.documents.compactMap { try $0.data(as: CommentEntity.self) }
                        completion(.success(commentEntity))
                    } catch let error {
                        print(error.localizedDescription)
                        completion(.failure(.commentFetchError))
                    }
                } else {
                    completion(.failure(.commentFetchError))
                }
            }
    }
    
    func fetchCommentsCount(postID: String, completion: @escaping (Result<Int, FirebaseError>) -> Void) {
        commentDB
            .whereField("postID", isEqualTo: postID)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.commentFetchError))
                } else {
                    if let querySnapshot = querySnapshot {
                        completion(.success(querySnapshot.count))
                    } else {
                        completion(.failure(.commentFetchError))
                    }
                }
            }
    }
}
