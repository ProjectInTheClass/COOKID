//
//  FirebaseTest.swift
//  CookidTests
//
//  Created by 박형석 on 2021/11/10.
//

import XCTest
@testable import Cookid

class FirebaseTest: XCTestCase {
    
    var repoProvider: RepositoryProvider!
    var currentUser: User!
    var newPost: Post!
    var updatedPost: Post!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.repoProvider = RepositoryProvider()
        
        self.currentUser = User(id: "phs880623", image: URL(string: "https://images.unsplash.com/photo-1608265386093-9b242ca91b6e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1096&q=80"), nickname: "형석", determination: "열심히 아껴서 M1 pro 사자!", priceGoal: 300000, userType: .preferDineIn, dineInCount: 40, cookidsCount: 20)
        
        self.newPost = Post(postID: "testPostID", user: currentUser,
                            images: [
                             URL(string: "https://images.unsplash.com/photo-1635982990748-6ba76f8ab4b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
                             URL(string: "https://images.unsplash.com/photo-1598184274576-e4fccfd84c7a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1972&q=80")
                            ],
                            likes: 0, collections: 0, star: 0, caption: "굿", mealBudget: 4000, location: "제주도", timeStamp: Date(), didLike: false, didCollect: false)
        
        self.updatedPost = Post(postID: "testPostID", user: currentUser,
                                images: [
                                 URL(string: "https://images.unsplash.com/photo-1635982990748-6ba76f8ab4b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
                                 URL(string: "https://images.unsplash.com/photo-1619700951946-2e2416825027?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=688&q=80")
                                ],
                                likes: 0, collections: 0, star: 3, caption: "굿 안녕하세요!", mealBudget: 2000, location: "부산", timeStamp: Date(), didLike: false, didCollect: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.repoProvider = nil
    }

    func test_WhenUserCreatePost() {

        let exp = self.expectation(description: "Waiting for async operation")

        repoProvider.firestorePostRepo.createPost(post: newPost) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreDeletePost() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.deletePost(deletePost: newPost) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreFetchPosts() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.fetchPastPosts(userID: newPost.user.id) { result in
            switch result {
            case .success(let postEntity):
                if let entity = postEntity.first {
                    XCTAssertEqual(entity.postID, self.newPost.postID)
                    XCTAssertEqual(entity.userID, self.newPost.user.id)
                    exp.fulfill()
                } else {
                    XCTFail("create error")
                }
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreUpdatePost() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.updatePost(updatedPost: updatedPost) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreReportPost() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.reportPost(userID: UUID().uuidString, postID: newPost.postID, isReport: true) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreHeartPost() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.heartPost(userID: currentUser.id, postID: newPost.postID, isHeart: true) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_FirestoreBookmarkPost() {
        let exp = self.expectation(description: "Waiting for async operation")
        repoProvider.firestorePostRepo.bookmarkPost(userID: currentUser.id, postID: newPost.postID, isBookmark: true) { result in
            switch result {
            case .success(let success):
                print(success)
                exp.fulfill()
            default:
                XCTFail("create error")
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }

}
