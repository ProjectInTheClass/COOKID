//
//  CookidTests.swift
//  CookidTests
//
//  Created by 박형석 on 2021/08/11.
//

import XCTest
@testable import Cookid
@testable import FirebaseFirestore
@testable import FirebaseStorage
@testable import RealmSwift

class CookidTests: XCTestCase {
    
    var postRepo: FirestorePostRepo!
    var reaml: Realm!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // 여기에 설정 코드를 입력하십시오. 이 메서드는 클래스의 각 테스트 메서드를 호출하기 전에 호출됩니다. 보통 테스트 케이스에서 공통으로 사용되는 뭔가를 정의해서 사용하면 됩니다.
        postRepo = FirestorePostRepo()
        reaml = try Realm()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // 여기에 해체 코드를 넣습니다. 이 메서드는 클래스의 각 테스트 메서드를 호출한 후 호출됩니다.  setUp에서 설정한 값들을 해제할 필요가 있을 때 사용합니다.
        postRepo = nil
        reaml = nil
        try super.tearDownWithError()
    }
    
    // Note: It’s good practice creating the SUT in setUpWithError() and releasing it in tearDownWithError() to ensure every test starts with a clean slate.
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // 이것은 기능 테스트 사례의 예입니다.
        // XCTAssert 및 관련 기능을 사용하여 테스트 결과가 올바른지 확인합니다.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        // 이것은 성능 테스트 사례의 예입니다.
        measure {
            // 여기에 시간을 측정할 코드를 입력합니다.
        }
    }
    
    func testFireStoreCreateTest() {
        // given : 필요한 모든 값을 set up. 예를 들어, 추측되는 값을 생성하고 타겟과 얼마나 다른지를 특정할 수 있다. 예를 들어 유저가 넣게 되는 값, userActions이 되겠지?
        // when : 유저의 action이 들어왔을 때, 수행하게 되는 함수
        // then : 결과검사
        // XCTAssertEqual("wef", "wef", "false")
    }
    
    func testAsyncronizedMethods() throws {
        
        try XCTSkipUnless(true)
        
        // XCTestExpectation를 사용해서 비동기 작업이 완료될 때까지 테스트를 대기하는데 사용한다. 이 테스트는 비교적 느리기 때문에 다른 테스트와 별도로 유지해야 한다. 이 메소드처럼 새로운 메소드를 만든다. 마찬가지 순서대로 진행한다.
        
        // given
        
//        let foodImageURL1 = URL(string: "https://images.unsplash.com/photo-1618107057892-67f36135fe17?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80")!
//        let foodImageURL2 = URL(string: "https://images.unsplash.com/photo-1597484389225-c68a9f0fa106?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=686&q=80")!
//        let newPost = Post(user: DummyData.shared.singleUser, images: [foodImageURL1, foodImageURL2], caption: "오늘 내가 먹은 음식들 짱 맛있다아~~", mealBudget: 23000, location: "제주도")
        
        /// 'expectation' can be fulfilled when asynchronous tasks in your tests complete.
//        let promise = expectation(description: "post is uploaded successfully")
        
        // when
        
//        var result: String?
        
//        postRepo.asyncTask { str in
//            result = str
//            promise.fulfill()
//        }
//
//        wait(for: [promise], timeout: 5.0)
//
//        XCTAssertNotNil(result)
    }
}
