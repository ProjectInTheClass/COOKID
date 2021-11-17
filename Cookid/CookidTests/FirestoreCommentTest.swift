//
//  FirestoreCommentTest.swift
//  CookidTests
//
//  Created by 박형석 on 2021/11/13.
//

import XCTest
@testable import FirebaseFirestore
@testable import FirebaseFirestoreSwift
@testable import Cookid

class FirestoreCommentTest: XCTestCase {
    
    let repoProvider = RepositoryProvider()
    let commentDB = Firestore.firestore().collection("comment")
    var newComment: Comment!
    var currentUser: User!
    
    override func setUpWithError() throws {
        self.currentUser = User(id: "phs880623", image: URL(string: "https://images.unsplash.com/photo-1608265386093-9b242ca91b6e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1096&q=80"), nickname: "형석", determination: "열심히 아껴서 M1 pro 사자!", priceGoal: 300000, userType: .preferDineIn, dineInCount: 40, cookidsCount: 20)
        
        self.newComment = Comment(commentID: "comment2", postID: "testPostID4", parentID: nil, user: currentUser, content: "finish", timestamp: Date(), didLike: false, likes: 0)
    }

    override func tearDownWithError() throws {
        self.currentUser = nil
        self.newComment = nil
    }

    func test_FirestoreCreateComment() {
        let exp = expectation(description: "for async")
        do {
            try commentDB.document(newComment.commentID).setData(from: convertCommentToEntity(newComment), merge: false) { error in
                if let error = error {
                    XCTFail("create Fail \(error)")
                } else {
                    exp.fulfill()
                }
            }
        } catch {
            XCTFail("create Fail")
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreDeleteComment() {
        let exp = expectation(description: "for async")
        commentDB.document(newComment.commentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
                XCTFail("delete Fail")
            } else {
                print("Document successfully removed!")
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreReportTransaction() {
        let exp = expectation(description: "for async")
        commentDB.document(newComment.commentID).firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else {
                XCTFail("delete Fail")
                return nil }
            let commentDocument: DocumentSnapshot
            do {
                try commentDocument = transaction.getDocument(self.commentDB.document(self.newComment.commentID))
                guard var commentEntity = try commentDocument.data(as: CommentEntity.self) else {
                    XCTFail("delete Fail")
                    return nil }
                
                commentEntity.isReported.append(self.currentUser.id)
                transaction.updateData([
                    "isReported": commentEntity.isReported
                ], forDocument: self.commentDB.document(self.newComment.commentID))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        } completion: { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                XCTFail("delete Fail")
            } else {
                print("Transaction successfully committed!")
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreFetchComments() {
        let exp = expectation(description: "for async")
        commentDB
            .whereField("postID", isEqualTo: "testPostID4")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    XCTFail("fetch Fail")
                } else if let querySnapshot = querySnapshot {
                    do {
                        let commentEntity = try querySnapshot.documents.compactMap { try $0.data(as: CommentEntity.self) }
                        XCTAssertEqual(commentEntity.count, 2)
                        exp.fulfill()
                    } catch let error {
                        print(error.localizedDescription)
                        XCTFail("fetch Fail")
                    }
                } else {
                    XCTFail("fetch Fail")
                }
            }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreFetchCommentsCount() {
        let exp = expectation(description: "fetch comment async")
        // 등호(=) 또는 in 절에 포함된 필드별로 쿼리 순서를 지정할 수 없습니다.
        commentDB
            .whereField("postID", isEqualTo: "testPostID4")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    XCTFail("fetch Fail")
                } else {
                    XCTAssertEqual(querySnapshot?.count, 2)
                    exp.fulfill()
                }
            }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func convertCommentToEntity(_ comment: Comment) -> CommentEntity {
        return CommentEntity(commentID: comment.commentID, postID: comment.postID, parentID: comment.parentID, userID: comment.user.id, content: comment.content, timestamp: comment.timestamp, didLike: [], isReported: [])
    }
    
    func convertEntityToComment(currentUser: User, entity: CommentEntity?) -> Comment? {
        guard let entity = entity else { return nil }
        return Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: currentUser, content: entity.content, timestamp: entity.timestamp, didLike: false, likes: 0)
    }
   

}
