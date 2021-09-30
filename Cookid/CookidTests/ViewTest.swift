//
//  ViewTest.swift
//  CookidTests
//
//  Created by 박형석 on 2021/09/29.
//

import XCTest
import RxSwift
@testable import Cookid

class ViewTest: XCTestCase {
    
    var reactor: AddPostReactor!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        let firestorePostRepo = FirestorePostRepo()
        let postService = PostService(firestoreRepo: firestorePostRepo)
        let userService = UserService()
        reactor = AddPostReactor(postID: UUID().uuidString, postService: postService, userService: userService)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        reactor = nil
        disposeBag = nil
    }

}
