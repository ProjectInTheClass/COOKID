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
    var firebaseStorageRepo: FirebaseStorageRepo!
    var postService: PostService!
    var userService: UserService!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        firestorePostRepo = FirestorePostRepo()
        firebaseStorageRepo = FirebaseStorageRepo()
        postService = PostService(firestoreRepo: firestorePostRepo, firebaseStorageRepo: firebaseStorageRepo)
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
        
        let reactor = AddPostReactor(postService: postService, userService: userService)
        
        let images = [
            UIImage(systemName: "circle.grid.cross.fill")!,
            UIImage(systemName: "circle.grid.cross.left.fill")!,
            UIImage(systemName: "circle.grid.cross.up.fill")!
        ]
        
        reactor.action.onNext(.userSetting)
        reactor.action.onNext(.imageUpload(images))
        reactor.action.onNext(.inputRegion("제주도"))
        reactor.action.onNext(.inputCaption("너무 맛있는 식사였습니다! 가성비 최고!"))
        reactor.action.onNext(.inputPrice(30000))
        reactor.action.onNext(.inputStar(5))
        reactor.action.onNext(.uploadPostButtonTapped)
     
        XCTAssertEqual(reactor.currentState.images.count, 3)
        XCTAssertEqual(reactor.currentState.postValue.region, "제주도")
        XCTAssertEqual(reactor.currentState.postValue.caption, "너무 맛있는 식사였습니다! 가성비 최고!")
        XCTAssertEqual(reactor.currentState.postValue.price, 30000)
        XCTAssertEqual(reactor.currentState.postValue.star, 5)
        XCTAssertEqual(reactor.currentState.isError, false)
    }
    
}
