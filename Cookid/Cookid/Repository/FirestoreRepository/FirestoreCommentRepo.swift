//
//  FirestoreCommentRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreCommentRepo {
    static let instance = FirestoreCommentRepo()
    
    private let commentDB = Firestore.firestore().collection("comment")

    func createComment(comment: Comment, completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(.successSignIn))
        }
    }
    
    func updateComment(comment: Comment) {
        print(comment.commentID)
    }
    
    func fetchComments(postID: String, completion: @escaping ([CommentEntity]) -> Void) {
        completion([
            CommentEntity(commentID: "", postID: postID, userID: "", content: "오와 맛있게다아", timestamp: Date(), isSubComment: false, didLike: [:], isReported: [:]),
            CommentEntity(commentID: "", postID: postID, userID: "", content: "굿굿!!", timestamp: Date(), isSubComment: false, didLike: [:], isReported: [:])
        ])
    }
    
    func deleteComment(comment: Comment) {
        print(comment.commentID)
    }
}
