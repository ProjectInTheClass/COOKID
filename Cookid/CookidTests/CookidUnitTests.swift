//
//  CookidUnitTests.swift
//  CookidTests
//
//  Created by 박형석 on 2021/11/23.
//

import XCTest
@testable import Cookid

class CookidUnitTests: XCTestCase {
    
    let testValue = true

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FailExample() throws {
        XCTFail()
    }
    
    func test_SuccessExample() {
        XCTAssertEqual(testValue, true)
    }

}
