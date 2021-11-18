//
//  FirestoreUserTest.swift
//  CookidTests
//
//  Created by 박형석 on 2021/11/13.
//

import XCTest
@testable import FirebaseFirestore
@testable import FirebaseFirestoreSwift
@testable import Cookid

class FirestoreUserTest: XCTestCase {
    
    var user: User!
    let userDB = Firestore.firestore().collection("user")

    override func setUpWithError() throws {
        self.user = User(id: "fourth", image: URL(string: "https://images.unsplash.com/photo-1608265386093-9b242ca91b6e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1096&q=80"), nickname: "디폴트", determination: "열심히 아껴서 M1X사자!", priceGoal: 300000, userType: .preferDineIn, dineInCount: 0, cookidsCount: 0)
    }

    override func tearDownWithError() throws {
        self.user = nil
    }
    
    func test_connectLocaUserWithRemoteUser() {
        let exp = expectation(description: "Waiting for async operation")
        do {
            try self.userDB.document(user.id).setData(from: convertUserToEntity(user: user)) { error in
                if let error = error {
                    XCTFail("Error writing user to Firestore: \(error)")
                } else {
                    exp.fulfill()
                }
            }
        } catch let error {
            XCTFail("Error writing user to Firestore: \(error)")
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func test_fetchUser() {
        let exp = expectation(description: "Waiting for async operation")
        userDB.document(user.id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                XCTFail("Error writing user to Firestore: \(error)")
            } else if let document = document {
                do {
                    guard let userEntity = try document.data(as: UserEntity.self) else { return }
                    XCTAssertEqual(userEntity.id, self.user.id)
                    exp.fulfill()
                } catch let error {
                    XCTFail("Error writing user to Firestore: \(error)")
                    
                }
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_updateUserInformation() {
        let exp = expectation(description: "Waiting for async operation")
        
        let updatedUser = User(id: user.id, image: user.image, nickname: "updatenickname", determination: "update dertermination", priceGoal: 1512351, userType: .preferDineOut, dineInCount: 0, cookidsCount: 0)
        
        let priceGoal = updatedUser.priceGoal
        let userType = updatedUser.userType.rawValue
        let nickname = updatedUser.nickname
        let determination = updatedUser.determination
        
        userDB.document(user.id).getDocument { document, _ in
            if let document = document, document.exists {
                document.reference.updateData([
                    "priceGoal": priceGoal,
                    "userType" : userType,
                    "nickname" : nickname,
                    "determination" : determination
                ]) { error in
                    if let error = error {
                        XCTFail("Error writing user to Firestore: \(error)")
                    } else {
                        exp.fulfill()
                    }
                }
            } else {
                XCTFail("Error writing user to Firestore")
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_fetchRankers() {
        let exp = expectation(description: "Waiting for async operation")
        userDB
            .order(by: "cookidsCount", descending: true).limit(to: 30)
            .getDocuments { querySnapshot, error in
            if let error = error {
                XCTFail("Error writing user to Firestore: \(error)")
            } else if let querySnapshot = querySnapshot {
                do {
                    let userEntity = try querySnapshot.documents.compactMap { try $0.data(as: UserEntity.self) }
                    for i in 0..<userEntity.count-1 {
                        XCTAssertTrue(userEntity[i].cookidsCount > userEntity[i+1].cookidsCount)
                        print(userEntity[i].id)
                    }
                    exp.fulfill()
                } catch let error {
                    XCTFail("Error writing user to Firestore: \(error)")
                }
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func test_TransactionCookidCount() {
        
        let exp = expectation(description: "test_TransactionCookidCount")
        
        // 처음 커넥팅 때는 그 정보가 올라감
        // 그 이후로는 트랜잭션으로 해당 내용을 업데이트
        userDB.document("619516377c5585b50f3b3a4c").firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(self.userDB.document("619516377c5585b50f3b3a4c"))
                guard var userEntity = try userDocument.data(as: UserEntity.self) else { return nil }
                userEntity.cookidsCount += 1
                transaction.updateData([
                    "cookidsCount": userEntity.cookidsCount
                ], forDocument: self.userDB.document("619516377c5585b50f3b3a4c"))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                XCTFail("cookid transaction fail")
                return nil
            }
        } completion: { _, error in
            if let error = error {
                XCTFail("cookid transaction fail \(error)")
            } else {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)

    }
    
    func test_userImageURLChange() {
        let exp = expectation(description: "test_TransactionCookidCount")
        
        // 처음 커넥팅 때는 그 정보가 올라감
        // 그 이후로는 트랜잭션으로 해당 내용을 업데이트
        userDB.document("619516377c5585b50f3b3a4c").firestore.runTransaction { [weak self] transaction, errorPointer in
            guard let self = self else { return nil }
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(self.userDB.document("619516377c5585b50f3b3a4c"))
                guard var userEntity = try userDocument.data(as: UserEntity.self) else { return nil }
                userEntity.imageURL = "https://images.unsplash.com/photo-1636972677998-d76f527e5576?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1082&q=80"
                transaction.updateData([
                    "imageURL": userEntity.imageURL
                ], forDocument: self.userDB.document("619516377c5585b50f3b3a4c"))
                return nil
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                XCTFail("cookid transaction fail")
                return nil
            }
        } completion: { _, error in
            if let error = error {
                XCTFail("cookid transaction fail \(error)")
            } else {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func convertEntityToUser(entity: UserEntity?) -> User? {
        guard let entity = entity else { return nil }
        return User(id: entity.id, image: URL(string: entity.imageURL), nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
    }
    
    func convertUserToEntity(user: User) -> UserEntity {
        return UserEntity(id: user.id, imageURL: user.image!.absoluteString, nickname: user.nickname, determination: user.determination, priceGoal: user.priceGoal, userType: user.userType.rawValue, dineInCount: user.dineInCount, cookidsCount: user.cookidsCount)
    }

}
