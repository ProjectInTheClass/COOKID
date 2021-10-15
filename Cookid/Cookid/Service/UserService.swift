//
//  UserService.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/08.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class UserService {
    
    let firestoreUserRepo: FirestoreUserRepo
    
    init(firestoreUserRepo: FirestoreUserRepo) {
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    /// Fetch from Realm
    private var defaultUserInfo = RealmUserRepo.instance.fetchUser().map { userentity -> User in
        return User(id: userentity.id.stringValue, image: URL(string: "https://www.vippng.com/png/detail/171-1717034_png-file-blank-person.png"), nickname: userentity.nickName, determination: userentity.determination, priceGoal: userentity.goal, userType: UserType(rawValue: userentity.type) ?? .preferDineIn, dineInCount: 0, cookidsCount: 0)
    } ?? DummyData.shared.singleUser
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    
    func user() -> Observable<User> {
        return userInfo
    }
    
    @discardableResult
    func loadMyInfo() -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestoreUserRepo.loadUser(user: self.defaultUserInfo) { result in
                switch result {
                case .success(let entity):
                    guard let entity = entity else { return }
                    let user = User(id: entity.id, image: entity.imageURL, nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
                    self.defaultUserInfo = user
                    self.userInfo.onNext(user)
                    observer.onNext(user)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    /// Fetch from Firebase
    @discardableResult
    func loadUserInfo(user: User) -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestoreUserRepo.fetchUser(userID: user.id) { result in
                switch result {
                case .success(let entity):
                    guard let entity = entity else { return }
                    let user = User(id: entity.id, image: entity.imageURL, nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
                    observer.onNext(user)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    /// Create in Realm
    func uploadUserInfo(user: User) {
        RealmUserRepo.instance.createUser(user: user) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.defaultUserInfo = user
                self.userInfo.onNext(self.defaultUserInfo)
            }
        }
    }
    
    /// Upload at Firebase
    func connectUserInfo(localUser: LocalUser, imageURL: URL?, dineInCount: Int, cookidsCount: Int, completion: @escaping (Bool) -> Void) {
        let connectedUser = User(id: localUser.id.stringValue, image: imageURL, nickname: localUser.nickName, determination: localUser.determination, priceGoal: localUser.goal, userType: UserType(rawValue: localUser.type) ?? .preferDineIn, dineInCount: dineInCount, cookidsCount: cookidsCount)
        self.defaultUserInfo = connectedUser
        self.userInfo.onNext(self.defaultUserInfo)
        completion(true)
        
        DispatchQueue.global(qos: .background).async {
            self.firestoreUserRepo.createUser(user: connectedUser) { _ in }
        }
    }
    
    // update
    func updateUserInfo(user: User, completion: @escaping ((Bool) -> Void)) {
        if user.image != nil,
           user.cookidsCount != nil,
           user.dineInCount != nil {
//            FireStoreUserRepo.instance.updateUser(updateUser: user)
        }
        RealmUserRepo.instance.updateUser(user: user)
        defaultUserInfo = user
        userInfo.onNext(user)
        completion(true)
    }
    
    func fetchCookidRankers() -> Observable<[User]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestoreUserRepo.fetchCookidsRankers { result in
                switch result {
                case .success(let userEntities):
                    let users = userEntities.map { User(id: $0.id, image: $0.imageURL, nickname: $0.nickname, determination: $0.determination, priceGoal: $0.priceGoal, userType: UserType(rawValue: $0.userType) ?? .preferDineIn, dineInCount: $0.dineInCount, cookidsCount: $0.cookidsCount) }
                    observer.onNext(users)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchDineInRankers() -> Observable<[User]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestoreUserRepo.fetchDineInRankers { result in
                switch result {
                case .success(let userEntities):
                    let users = userEntities.map { User(id: $0.id, image: $0.imageURL, nickname: $0.nickname, determination: $0.determination, priceGoal: $0.priceGoal, userType: UserType(rawValue: $0.userType) ?? .preferDineIn, dineInCount: $0.dineInCount, cookidsCount: $0.cookidsCount) }
                    observer.onNext(users)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func filteringTopRankers(_ users: [User]) -> [User] {
        var topRankers = [User]()
        for (index, user) in users.enumerated() {
            if index < 3 {
                topRankers.append(user)
            }
        }
        return topRankers
    }
    
    
}
