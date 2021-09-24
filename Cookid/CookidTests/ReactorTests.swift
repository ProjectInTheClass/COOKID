//
//  Reactor.swift
//  CookidTests
//
//  Created by 박형석 on 2021/09/24.
//

import XCTest
import ReactorKit
@testable import Cookid

class Reactor: XCTestCase {
    
    func testAddPostReactor_forAddImageCase() {
        let postService = PostService()
        let userService = UserService()
        let reactor = AddPostReactor(postService: postService, userService: userService)
        reactor.action.onNext(.selectImageButton)
        XCTAssertEqual(reactor.currentState.images.count, 1)
    }

}
