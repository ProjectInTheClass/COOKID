//
//  FirestoreCommentRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
//import Firebase

class FirestoreCommentRepo {
    static let instance = FirestoreCommentRepo()
    
    //    private let commentDB = Firestore.firestore().collection("comment")
    
    var commentDB = [
        CommentEntity(commentID: "comment1", postID: "post1", parentID: nil, userID: "json", content: "love and peace", timestamp: Date(), didLike: ["json" : true], isReported: [:]),
        CommentEntity(commentID: "comment2", postID: "post1", parentID: nil, userID: "mary", content: "peace and love", timestamp: Date(), didLike: [:], isReported: [:]),
        CommentEntity(commentID: "comment3", postID: "post2", parentID: nil, userID: "sara", content: "friend and peace", timestamp: Date(), didLike: ["json" : true], isReported: [:]),
        CommentEntity(commentID: "comment4", postID: "post2", parentID: nil, userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: ["sara": true]),
        CommentEntity(commentID: "comment5", postID: "post1", parentID: "comment1", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: ["sara": true]),
        CommentEntity(commentID: "comment6", postID: "post1", parentID: "comment2", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: [:]),
        CommentEntity(commentID: "comment7", postID: "post2", parentID: "comment3", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: [:]),
        CommentEntity(commentID: "comment8", postID: "post2", parentID: "comment4", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: [:]),
        CommentEntity(commentID: "comment9", postID: "post1", parentID: "comment1", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: [:]),
        CommentEntity(commentID: "comment10", postID: "post2", parentID: "comment3", userID: "risa", content: "love and friend", timestamp: Date(), didLike: ["risa" : true], isReported: [:])
    ]
    
    func createComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let commentEntity = CommentEntity(commentID: comment.commentID, postID: comment.postID, parentID: comment.parentID, userID: comment.user.id, content: comment.content, timestamp: comment.timestamp, didLike: [:], isReported: [:])
            self.commentDB.append(commentEntity)
            print(self.commentDB.count)
            completion(.success(.createCommentSuccess))
        }
    }
    
    func deleteComment(comment: Comment, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            print("CommentRepo deleteComment call")
            completion(.success(.deleteCommentSuccess))
        }
    }
    
    func fetchComments(postID: String, completion: @escaping (Result<[CommentEntity], FirebaseError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(self.commentDB.filter({ $0.postID == postID})))
        }
    }
}
