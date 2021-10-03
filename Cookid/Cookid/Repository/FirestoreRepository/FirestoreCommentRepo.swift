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

    func createComment(comment: Comment, completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(.successSignIn))
        }
    }
    
    func fetchComments(postID: String, completion: @escaping ([CommentEntity]) -> Void) {
        // 파이어베이스 comments db에서 postID이고 parentID가 nil인 댓글을 최신순으로 불러온다.
        print("CommentRepo fetchComments call")
        completion([])
    }
    
    func fetchSubComments(postID: String, parentID: String, completion: @escaping ([CommentEntity]) -> Void) {
        // 파이어베이스 comments db에서 postID와 parentID에 일치하는 댓글을 최신순으로 5개씩 불러온다.
        print("CommentRepo fetchSubComments call")
        completion([])
    }
    
    func deleteComment(comment: Comment) {
        
    }
}
