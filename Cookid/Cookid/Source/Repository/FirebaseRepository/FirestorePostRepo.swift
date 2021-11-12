//
//  FirestorePostRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias FirebaseResult = (Result<FirebaseSuccess, FirebaseError>) -> Void
typealias PostResult =  (Result<[PostEntity], FirebaseError>) -> Void

protocol PostRepoType {
    func createPost(post: Post, completion: @escaping FirebaseResult)
    func fetchLatestPosts(userID: String, completion: @escaping PostResult)
    func fetchPastPosts(userID: String, completion: @escaping PostResult)
    func fetchMyPosts(userID: String, completion: @escaping PostResult)
    func fetchBookmarkedPosts(userID: String, completion: @escaping PostResult)
    func updatePost(updatedPost: Post, completion: @escaping FirebaseResult)
    func deletePost(deletePost: Post, completion: @escaping FirebaseResult)
    func reportPost(reportedPost: Post, completion: @escaping FirebaseResult)
    func updatePostHeart(userID: String, postID: String, isHeart: Bool, completion: @escaping FirebaseResult)
    func updatePostBookmark(userID: String, postID: String, isBookmark: Bool, completion: @escaping FirebaseResult)
}

final class FirestorePostRepo: BaseRepository, PostRepoType {
    
    let postDB = Firestore.firestore().collection("post")

    /// upload new post
    /// by this method, collect all the posts in one place.
    func createPost(post: Post, completion: @escaping FirebaseResult) {
        // 포스트를 받아서 entity로 변환한 뒤 업로드
        let images = post.images.map { url -> String in
            guard let urlString = url?.absoluteString else { return "" }
            return urlString
        }
        let postEntity = PostEntity(postID: post.postID, userID: post.user.id, images: images, star: 0, caption: post.caption, mealBudget: post.mealBudget, timestamp: post.timeStamp, location: post.location, didLike: [:], didCollect: [:], isReported: [:])
        
        do {
            try postDB.document(post.postID).setData(from: postEntity, completion: { error in
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(.postUploadError))
                    return
                }
                
                // Adding the document was successful
                completion(.success(.postUploadSuccess))
            })
        } catch let error {
            print("Error writing postEntity to Firestore: \(error)")
            completion(.failure(.postUploadError))
        }
    }
    
    /// update specific post's contents
    func updatePost(updatedPost: Post, completion: @escaping FirebaseResult) {
        // 기존 내용 덮어쓰기
        // 포스트를 받아서 entity로 변환한 뒤 업데이트
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(.postUploadSuccess))
        }
    }
    
    /// delete specific post
    func deletePost(deletePost: Post, completion: @escaping FirebaseResult) {
        // 해당 포스트를 찾아서 삭제하는 API 구현
        postDB.document(deletePost.postID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(.failure(.deletePostError))
            } else {
                print("Document successfully removed!")
                completion(.success(.deletePostSuccess))
            }
        }
    }
    
    /// report specific post
    func reportPost(reportedPost: Post, completion: @escaping FirebaseResult) {
        // 해당 포스트를 찾아서 리포트에 해당 유저 ID를 넣는 API 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(.reportPostSuceess))
        }
    }
    
    /// fetch new posts when tableView was scrolled top of it
    /// userID: this parameter is used to filtering user's isReport list
    func fetchLatestPosts(userID: String, completion: @escaping PostResult) {
        // 최신 10개의 정렬된 데이터 받기
      
    }
    
    /// fetch 10 past posts at once when tableview was scrolled until bottom point
    /// userID: this parameter is used to filtering user's isReport list
    func fetchPastPosts(userID: String, completion: @escaping PostResult) {
        // firebase에서 시간 순서 대로 10개씩 받기
        postDB.order(by: "timestamp", descending: true).limit(to: 10)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.postFetchError))
            } else if let querySnapshot = querySnapshot {
                
                let result = Result {
                    try querySnapshot.documents
                }
                
                switch result {
                    case .success(let city):
                        if let city = city {
                            // A `City` value was successfully initialized from the DocumentSnapshot.
                            print("City: \(city)")
                        } else {
                            // A nil value was successfully initialized from the DocumentSnapshot,
                            // or the DocumentSnapshot was nil.
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        // A `City` value could not be initialized from the DocumentSnapshot.
                        print("Error decoding city: \(error)")
                    }
                
            }
        }
    }
    
    /// fetch specific user post from firebase
    /// this method use userID both query user's posts and filtering user's isReport list
    func fetchMyPosts(userID: String, completion: @escaping PostResult) {
        // 쿼리와 받아오기가 완료된 엔티티
    }
    
    /// fetch bookmarked posts from firebase
    /// this method use userID both query user's posts and filtering user's isReport list
    func fetchBookmarkedPosts(userID: String, completion: @escaping PostResult) {
        
        // 리포트 여부, userID 일치 여부, 북마크 여부 -> 모두 가능한 녀석을 fetch
        // firebase 쿼리 최대한 적용
        // 10개만 가져오도록 -> 테이블뷰 인피니티에 걸리면 다시 로드하는 방식으로 할거야
        
        // 쿼리와 받아오기가 완료된 엔티티
    }
    
    func updatePostHeart(userID: String, postID: String, isHeart: Bool, completion: @escaping FirebaseResult) {
        
    }
    
    func updatePostBookmark(userID: String, postID: String, isBookmark: Bool, completion: @escaping FirebaseResult) {
        
    }
  
}
