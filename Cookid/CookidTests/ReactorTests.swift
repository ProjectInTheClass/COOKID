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
    
    var postService: PostService!
    var userService: UserService!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        postService = PostService()
        userService = UserService()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        postService = nil
        userService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    func testAddPostReactorTest_createPost() {
        let images = [
            UIImage(systemName: "person.circle")!,
            UIImage(systemName: "person.circle.fill")!,
            UIImage(systemName: "person")!
        ]
        
        let addPostReactor = AddPostReactor(postID: UUID().uuidString, postService: postService, userService: userService)
        addPostReactor.currentState.postImages.accept(images)
        addPostReactor.currentState.priceRelay.accept(50000)
        addPostReactor.currentState.placeRelay.accept("제주도")
        addPostReactor.currentState.starRelay.accept(4)
        addPostReactor.currentState.captionRelay.accept("갈치조림 맛있었습니당!")
        addPostReactor.action.onNext(.uploadPostButtonTapped)
        
        addPostReactor.currentState.newPost
            .bind { post in
                XCTAssertNil(post)
            }
            .disposed(by: disposeBag)
    }

}
