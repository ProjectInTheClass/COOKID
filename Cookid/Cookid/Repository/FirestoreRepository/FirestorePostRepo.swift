//
//  FirestorePostRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation
//import FirebaseFirestore
//import FirebaseStorage

class FirestorePostRepo {
    static let instance = FirestorePostRepo()

    ///upload new post
    ///by this method, collect all the posts in one place.
    func createPost(post: Post, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        // 포스트를 받아서 entity로 변환한 뒤 업로드
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(.postUploadSuccess))
        }
    }
    
    ///update specific post's contents
    func updatePost(updatedPost: Post, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        // 기존 내용 덮어쓰기
        // 포스트를 받아서 entity로 변환한 뒤 업데이트
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(.postUploadSuccess))
        }
    }
    
    ///delete specific post
    func deletePost(deletePost: Post, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        // 해당 포스트를 찾아서 삭제하는 API 구현
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(.postUploadSuccess))
        }
    }
    
    ///fetch new posts when tableView was scrolled top of it
    ///userID: this parameter is used to filtering user's isReport list
    func fetchLatestPosts(userID: String, completion: @escaping (Result<[PostEntity], FirebaseError>) -> Void) {
        // userID로 isReported 검수 후에 보내기
        // firebase에서 솔팅해서 받기
    }
    
    ///fetch 10 past posts at once when tableview was scrolled until bottom point
    ///userID: this parameter is used to filtering user's isReport list
    func fetchPastPosts(userID: String, completion: @escaping (Result<[PostEntity], FirebaseError>) -> Void) {
        // userID로 isReported 검수 후에 보내기
        // firebase에서 솔팅해서 받기
        
        guard let date1 = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        guard let date2 = Calendar.current.date(byAdding: .day, value: -2, to: Date()) else { return }
        guard let date3 = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else { return }
        guard let date4 = Calendar.current.date(byAdding: .day, value: -4, to: Date()) else { return }
        
        let postEntities = [
            PostEntity(postID: UUID().uuidString, userID: DummyData.shared.singleUser.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917374642-1a9020c5eb43?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 4, caption: "최고의 식사였다.", mealBudget: 10000,
                       timestamp: date1, location: "제주도", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: DummyData.shared.secondUser.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 2, caption: "덜 최고의 식사였다.", mealBudget: 3000,
                       timestamp: date2, location: "경북 구미", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: DummyData.shared.singleUser.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 0, caption: "보통의 식사였다.", mealBudget: 12000,
                       timestamp: date3, location: "부산", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: DummyData.shared.secondUser.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917374642-1a9020c5eb43?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 8, caption: "별로였다.", mealBudget: 50000,
                       timestamp: date4, location: "서울", didLike: [:], didCollect: [:], isReported: [:])
        ]
        completion(.success(postEntities))
    }
    
    ///fetch specific user post from firebase
    ///this method use userID both query user's posts and filtering user's isReport list
    func fetchMyPosts(userID: String, completion: @escaping (Result<[PostEntity], FirebaseError>) -> Void) {
        completion(.success([
            PostEntity(postID: UUID().uuidString, userID: userID,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917374642-1a9020c5eb43?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 4, caption: "최고의 식사였다.", mealBudget: 10000,
                       timestamp: Date(), location: "제주도", didLike: [:], didCollect: [:], isReported: [:])
        ]))
    }
    
    ///fetch bookmarked posts from firebase
    ///this method use userID both query user's posts and filtering user's isReport list
    func fetchBookmarkedPosts(user: User, completion: @escaping (Result<[PostEntity], FirebaseError>) -> Void) {
        
        // 리포트 여부, userID 일치 여부, 북마크 여부 -> 모두 가능한 녀석을 fetch
        // firebase 쿼리 최대한 적용
        // 10개만 가져오도록 -> 테이블뷰 인피니티에 걸리면 다시 로드하는 방식으로 할거야
        
        // 쿼리와 받아오기가 완료된 엔티티
        guard let date1 = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
        guard let date2 = Calendar.current.date(byAdding: .day, value: -2, to: Date()) else { return }
        guard let date3 = Calendar.current.date(byAdding: .day, value: -3, to: Date()) else { return }
        guard let date4 = Calendar.current.date(byAdding: .day, value: -4, to: Date()) else { return }
        
        let postEntities = [
            PostEntity(postID: UUID().uuidString, userID: user.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917374642-1a9020c5eb43?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 4, caption: "최고의 식사였다.", mealBudget: 10000,
                       timestamp: date1, location: "제주도", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: user.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 2, caption: "덜 최고의 식사였다.", mealBudget: 3000,
                       timestamp: date2, location: "경북 구미", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: user.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 0, caption: "보통의 식사였다.", mealBudget: 12000,
                       timestamp: date3, location: "부산", didLike: [:], didCollect: [:], isReported: [:]),
            PostEntity(postID: UUID().uuidString, userID: user.id,
                       images: [
                        URL(string: "https://images.unsplash.com/photo-1632917374642-1a9020c5eb43?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1632917463901-6d6a97f1fb5e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                        URL(string: "https://images.unsplash.com/photo-1633327760690-d9bb0513f942?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80")
                       ], star: 8, caption: "별로였다.", mealBudget: 50000,
                       timestamp: date4, location: "서울", didLike: [:], didCollect: [:], isReported: [:])
        ]
        
        let sortedPostEntities = postEntities.sorted { $0.timestamp > $1.timestamp }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.success(sortedPostEntities))
        }
    }
    
    func updatePostHeart(userID: String, postID: String, isHeart: Bool, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        completion(.success(.buttonTransactionSuccess))
    }
    
    func updatePostBookmark(userID: String, postID: String, isBookmark: Bool, completion: @escaping (Result<FirebaseSuccess, FirebaseError>) -> Void) {
        completion(.success(.buttonTransactionSuccess))
    }
  
}
