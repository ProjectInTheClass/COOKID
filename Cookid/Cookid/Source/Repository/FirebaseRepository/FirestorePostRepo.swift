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
typealias PostResult = (Result<[PostEntity], FirebaseError>) -> Void

protocol PostRepoType {
    func createPost(post: Post, completion: @escaping FirebaseResult)
    func fetchLatestPosts(userID: String, completion: @escaping PostResult)
    func fetchPastPosts(userID: String, completion: @escaping PostResult)
    func fetchMyPosts(userID: String, completion: @escaping PostResult)
    func fetchBookmarkedPosts(userID: String, completion: @escaping PostResult)
    func updatePost(updatedPost: Post, completion: @escaping FirebaseResult)
    func deletePost(deletePost: Post, completion: @escaping FirebaseResult)
    func reportPost(userID: String, postID: String, completion: @escaping FirebaseResult)
    func heartPost(userID: String, postID: String, isHeart: Bool, completion: @escaping FirebaseResult)
    func bookmarkPost(userID: String, postID: String, isBookmark: Bool, completion: @escaping FirebaseResult)
}

class FirestorePostRepo: BaseRepository, PostRepoType {
    
    private var currentDate = Date()
    private let postDB = Firestore.firestore().collection("post")

    /// upload new post
    /// by this method, collect all the posts in one place.
    func createPost(post: Post, completion: @escaping FirebaseResult) {
        // 포스트를 받아서 entity로 변환한 뒤 업로드
        let images = post.images.map { url -> String in
            guard let urlString = url?.absoluteString else { return "" }
            return urlString
        }
        let postEntity = PostEntity(postID: post.postID, userID: post.user.id, images: images, star: 0, caption: post.caption, mealBudget: post.mealBudget, timestamp: post.timeStamp, location: post.location, didLike: [], didCollect: [], isReported: [])
        
        do {
            try postDB.document(post.postID).setData(from: postEntity, merge: false, completion: { error in
                
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
        
        let images = updatedPost.images.map { url -> String in
            guard let urlString = url?.absoluteString else { return "" }
            return urlString
        }
        let updatedStar = updatedPost.star
        let updatedCaption = updatedPost.caption
        let updatedMealBudget = updatedPost.mealBudget
        let updatedLocation = updatedPost.location
        
        postDB.document(updatedPost.postID).getDocument { document, _ in
            if let document = document, document.exists {
                document.reference.updateData([
                    "images": images,
                    "star": updatedStar,
                    "caption" : updatedCaption,
                    "mealBudget" : updatedMealBudget,
                    "location" : updatedLocation
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(.failure(.postUpdateError))
                    } else {
                        completion(.success(.postUpdateSuceess))
                    }
                }
            } else {
                print("Document does not exist")
            }
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
    
    /// fetch new posts when tableView was scrolled top of it
    /// userID: this parameter is used to filtering user's isReport list
    func fetchLatestPosts(userID: String, completion: @escaping PostResult) {
        // 최신 10개의 정렬된 데이터 받기
        postDB.order(by: "timestamp", descending: true).limit(to: 10)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.postFetchError))
            } else if let querySnapshot = querySnapshot {
                do {
                    let postEntity = try querySnapshot.documents.compactMap { try $0.data(as: PostEntity.self) }
                    completion(.success(postEntity))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.postFetchError))
                }
            }
        }
    }
    
    /// fetch 10 past posts at once when tableview was scrolled until bottom point
    /// userID: this parameter is used to filtering user's isReport list
    func fetchPastPosts(userID: String, completion: @escaping PostResult) {
        // firebase에서 시간 순서 대로 10개씩 받기
        postDB
            .whereField("timestamp", isLessThanOrEqualTo: currentDate)
            .order(by: "timestamp", descending: true).limit(to: 10)
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.postFetchError))
            } else if let querySnapshot = querySnapshot {
                do {
                    let postEntity = try querySnapshot.documents.compactMap { try $0.data(as: PostEntity.self) }
                    if let lastPostEntity = postEntity.last {
                        guard let testPateDate = Calendar.current.date(byAdding: .second, value: -1, to: lastPostEntity.timestamp) else { return }
                        self.currentDate = testPateDate
                        completion(.success(postEntity))
                    } else {
                        completion(.success([]))
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.postFetchError))
                }
            }
        }
    }
    
    /// fetch specific user post from firebase
    /// this method use userID both query user's posts and filtering user's isReport list
    func fetchMyPosts(userID: String, completion: @escaping PostResult) {
        // 쿼리와 받아오기가 완료된 엔티티
        postDB.whereField("userID", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.postFetchError))
            } else if let querySnapshot = querySnapshot {
                do {
                    let postEntity = try querySnapshot.documents.compactMap { try $0.data(as: PostEntity.self) }
                    completion(.success(postEntity))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.postFetchError))
                }
            }
        }
    }
    
    /// fetch bookmarked posts from firebase
    /// this method use userID both query user's posts and filtering user's isReport list
    func fetchBookmarkedPosts(userID: String, completion: @escaping PostResult) {
        // 리포트 여부, userID 일치 여부, 북마크 여부 -> 모두 가능한 녀석을 fetch
        // firebase 쿼리 최대한 적용
        postDB
            .whereField("didCollect", arrayContains: userID)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.postFetchError))
            } else if let querySnapshot = querySnapshot {
                do {
                    let postEntity = try querySnapshot.documents.compactMap { try $0.data(as: PostEntity.self) }
                    completion(.success(postEntity))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.postFetchError))
                }
            }
        }
    }
    
    /// heart specific post with Firestore transaction
    func heartPost(userID: String, postID: String, isHeart: Bool, completion: @escaping FirebaseResult) {
        postDB.document(postID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(self.postDB.document(postID))
                guard var postEntity = try postDocument.data(as: PostEntity.self) else {
                    completion(.failure(.buttonTransactionError))
                    return nil }
                if isHeart {
                    postEntity.didCollect.append(userID)
                } else {
                    if let firstIndex = postEntity.didCollect.firstIndex(of: userID) {
                        postEntity.didCollect.remove(at: firstIndex)
                    }
                }
                transaction.updateData([
                    "didLike": postEntity.didLike
                ], forDocument: self.postDB.document(postID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(.failure(.buttonTransactionError))
            } else {
                print("Transaction successfully committed!")
                completion(.success(.buttonTransactionSuccess))
            }
        }
    }
    
    /// bookmark specific post with Firestore transaction
    func bookmarkPost(userID: String, postID: String, isBookmark: Bool, completion: @escaping FirebaseResult) {
        postDB.document(postID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(self.postDB.document(postID))
                guard var postEntity = try postDocument.data(as: PostEntity.self) else {
                    completion(.failure(.buttonTransactionError))
                    return nil }
                if isBookmark {
                    postEntity.didCollect.append(userID)
                } else {
                    if let firstIndex = postEntity.didCollect.firstIndex(of: userID) {
                        postEntity.didCollect.remove(at: firstIndex)
                    }
                }
                transaction.updateData([
                    "didCollect": postEntity.didCollect
                ], forDocument: self.postDB.document(postID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(.failure(.buttonTransactionError))
            } else {
                print("Transaction successfully committed!")
                completion(.success(.buttonTransactionSuccess))
            }
        }
    }
    
    /// report specific post with Firestore transaction
    func reportPost(userID: String, postID: String, completion: @escaping FirebaseResult) {
        postDB.document(postID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(self.postDB.document(postID))
                guard var postEntity = try postDocument.data(as: PostEntity.self) else { return nil }
                postEntity.isReported.append(userID)
                transaction.updateData([
                    "isReported": postEntity.isReported
                ], forDocument: self.postDB.document(postID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(.failure(.reportPostError))
            } else {
                print("Transaction successfully committed!")
                completion(.success(.reportPostSuceess))
            }
        }
    }
}
