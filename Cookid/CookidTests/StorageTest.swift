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
    let postImagesStorage = Storage.storage().reference().child("postImage")
    var userImage: UIImage!
    var updateUserImage: UIImage!
    var postImages: [UIImage]!
    let localUser = LocalUser(nickName: "디폴트", determination: "열심히 아껴서 M1X사자!", goal: 300000, type: "집밥러")
    
    override func setUpWithError() throws {
        self.userImage = UIImage(named: "placeholder")
        self.updateUserImage = UIImage(named: "bread")
        self.postImages = [
            UIImage(named: "placeholder")!,
            UIImage(named: "bread")!
        ]
    }
    
    override func tearDownWithError() throws {
        self.userImage = nil
    }
    
    func test_uploadUserImage() {
        let exp = self.expectation(description: "Waiting for async operation")
        
        guard let imageData = userImage.jpegData(compressionQuality: 0.25) else { return }
        let fileName = "asdfasdf"
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
    
    func test_updateUserImage() {
        // url의 토큰값이 다르다. url을 다시 받아서 저장해주느 방식으로 가자.
        let exp = self.expectation(description: "Waiting for async operation")
        
        guard let imageData = updateUserImage.jpegData(compressionQuality: 0.25) else { return }
        let fileName = "asdfasdf"
        print(fileName)
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
    
    func test_uploadPostImages() {
        let exp = self.expectation(description: "Waiting for async operation")
        
        let dispatchGroup = DispatchGroup()
        
        for (index, image) in postImages.enumerated() {
            dispatchGroup.enter()
            let fileName = "postID" + "\(index)"
            guard let imageData = image.jpegData(compressionQuality: 0.25) else { return }
            postImagesStorage.child(fileName).putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    XCTFail("fail to upload post Image to storage \(error)")
                } else {
                    self.postImagesStorage.child(fileName).downloadURL { url, _ in
                        guard let url = url else {
                            XCTFail("fail to upload post Image to storage \(error)")
                            return
                        }
                        print("---------->\(url)")
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_deletePostImages() {
        let exp = self.expectation(description: "Waiting for async operation")
        
        let dispatchGroup = DispatchGroup()
        
        for index in 0...2 {
            dispatchGroup.enter()
            let fileName = "postID" + "\(index)"
            postImagesStorage.child(fileName).delete { error in
                if let error = error {
                    dispatchGroup.leave()
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 15, handler: nil)
    }

}
