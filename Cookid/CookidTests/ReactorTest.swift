//
//  Reactor.swift
//  CookidTests
//
//  Created by 박형석 on 2021/09/24.
//
import XCTest
import RxSwift
import ReactorKit
@testable import Cookid

class Reactor: XCTestCase {
    
    var firestorePostRepo: FirestorePostRepo!
    var postService: PostService!
    var userService: UserService!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        firestorePostRepo = FirestorePostRepo()
        postService = PostService(firestoreRepo: firestorePostRepo)
        userService = UserService()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        postService = nil
        userService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    func testAddPostReactorTest_actionImageTest() {
        let reactor = AddPostReactor(postID: UUID().uuidString, postService: postService, userService: userService)
        
        let images = [
            UIImage(systemName: "circle.grid.cross.fill")!,
            UIImage(systemName: "circle.grid.cross.left.fill")!,
            UIImage(systemName: "circle.grid.cross.up.fill")!
        ]
        
        reactor.action.onNext(.imageUpload(images))
        XCTAssertEqual(reactor.currentState.images.count, 3)
    }
    
    func testAddPostReactorTest_actionPostTest() {
        
        let reactor = AddPostReactor(postID: UUID().uuidString, postService: postService, userService: userService)
        
        let images = [
            UIImage(systemName: "circle.grid.cross.fill")!,
            UIImage(systemName: "circle.grid.cross.left.fill")!,
            UIImage(systemName: "circle.grid.cross.up.fill")!
        ]
        
        reactor.action.onNext(.imageUpload(images))
        
        let user = User(id: UUID().uuidString, image: UIImage(systemName: "person.circle"), nickname: "형석이다.", determination: "화이팅", priceGoal: 300000, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)
        
        let post = Post(postID: reactor.postID, user: user, images: images, star: 4, caption: "맛있다", mealBudget: 40000, location: "제주도")
        
        reactor.action.onNext(.makePost(post))
        
        reactor.action.onNext(.uploadPostButtonTapped)
        
        XCTAssertTrue(reactor.currentState.uploadCompletion?.postID == post.postID)
    }
    
    func testPostService_UploadPost() {
        let reactor = AddPostReactor(postID: UUID().uuidString, postService: postService, userService: userService)
        let user = User(id: UUID().uuidString, image: UIImage(systemName: "person.circle"), nickname: "형석이다.", determination: "화이팅", priceGoal: 300000, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)
        let images = [
            UIImage(systemName: "circle.grid.cross.fill")!,
            UIImage(systemName: "circle.grid.cross.left.fill")!,
            UIImage(systemName: "circle.grid.cross.up.fill")!
        ]
        let post = Post(postID: reactor.postID, user: user, images: images, star: 4, caption: "맛있다", mealBudget: 40000, location: "제주도")
        
        postService.createPost(post: post)
        
        XCTAssertNotNil(postService.currentPosts, "equals")
        
    }

}
