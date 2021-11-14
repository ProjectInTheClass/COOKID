//
//  StorageTest.swift
//  CookidTests
//
//  Created by 박형석 on 2021/11/13.
//

import XCTest
@testable import FirebaseStorage
@testable import FirebaseStorageSwift
@testable import Cookid

class StorageTest: XCTestCase {
    
    let userImageStorage = Storage.storage().reference().child("userImage")
    var userImage: UIImage!
    var localUser: LocalUser!
    
    override func setUpWithError() throws {
        self.userImage = UIImage(named: "placeholder")
        self.localUser = LocalUser(nickName: "디폴트", determination: "열심히 아껴서 M1X사자!", goal: 300000, type: "집밥러")
    }
    
    override func tearDownWithError() throws {
        self.userImage = nil
        self.localUser = nil
    }
    
    func test_uploadUserImage() {
        let exp = self.expectation(description: "Waiting for async operation")
        
        guard let imageData = userImage.jpegData(compressionQuality: 0.25) else { return }
        let fileName = localUser.id.stringValue
        userImageStorage.child(fileName).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                XCTFail("fail to upload user Image to storage \(error)")
            } else {
                self.userImageStorage.child(fileName).downloadURL { url, _ in
                    guard let url = url else {
                        return
                    }
                    print(url)
                    exp.fulfill()
                }
            }
        }
        self.waitForExpectations(timeout: 15, handler: nil)
    }

}
