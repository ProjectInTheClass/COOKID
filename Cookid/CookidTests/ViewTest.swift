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
    
    func testAddPostVC_buttonValidation() {
        let view = AddPostViewController.instantiate(storyboardID: "Post")
        view.reactor = reactor
        view.loadViewIfNeeded()
        
        let images = [
            UIImage(systemName: "circle.grid.cross.fill")!,
            UIImage(systemName: "circle.grid.cross.left.fill")!,
            UIImage(systemName: "circle.grid.cross.up.fill")!
        ]
       
        let user = User(id: UUID().uuidString, image: UIImage(systemName: "person.circle"), nickname: "형석이다.", determination: "화이팅", priceGoal: 300000, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)
        
        let post = Post(postID: reactor.postID, user: user, images: images, star: 4, caption: "맛있다", mealBudget: 40000, location: "제주도")
        
        reactor.action.onNext(.makePost(post))
        
        view.captionTextView.rx.text.onNext("test caption")
        view.regionTextField.rx.text.onNext("test place")
       
        let imageView = AddPostImageCollectionViewController()
        imageView.reactor = reactor
        
        imageView.reactor?.action.onNext(.imageUpload(images))
        
        XCTAssertTrue(reactor.currentState.validation)
    }

}
