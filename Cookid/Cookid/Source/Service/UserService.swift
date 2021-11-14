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

protocol UserServiceType {
    var currentUser: Observable<User> { get }
    func creatUser(user: User, completion: @escaping (Bool) -> Void)
    func connectUser(localUser: LocalUser, imageURL: URL?, dineInCount: Int, cookidsCount: Int, completion: @escaping (Bool) -> Void)
    func loadMyInfo()
    func fetchUserInfo(user: User) -> Observable<User>
    func updateUserInfo(user: User, completion: @escaping (Bool) -> Void)
    func updateUserImage(user: User, profileImage: UIImage?, completion: @escaping (Bool) -> Void)
    func fetchCookidRankers() -> Observable<[User]>
}

class UserService: BaseService, UserServiceType {
    
    /// Fetch from Realm
    private lazy var defaultUserInfo = repoProvider.realmUserRepo.fetchUser().map { userentity -> User in
        return User(id: userentity.id.stringValue,
                    image: URL(string: "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1931&q=80"),
                    nickname: userentity.nickName,
                    determination: userentity.determination,
                    priceGoal: userentity.goal,
                    userType: UserType(rawValue: userentity.type) ?? .preferDineIn,
                    dineInCount: 0,
                    cookidsCount: 0)
    }!
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    
    var currentUser: Observable<User> {
        return userInfo
    }
    
    /// Create in Realm
    func creatUser(user: User, completion: @escaping (Bool) -> Void) {
        self.repoProvider.realmUserRepo.createUser(user: user) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.defaultUserInfo = user
                self.userInfo.onNext(self.defaultUserInfo)
            }
        }
    }
    
    /// Upload at Firebase with Local User
    func connectUser(localUser: LocalUser, imageURL: URL?, dineInCount: Int, cookidsCount: Int, completion: @escaping (Bool) -> Void) {
        let connectedUser = User(id: localUser.id.stringValue, image: imageURL, nickname: localUser.nickName, determination: localUser.determination, priceGoal: localUser.goal, userType: UserType(rawValue: localUser.type) ?? .preferDineIn, dineInCount: dineInCount, cookidsCount: cookidsCount)
        self.defaultUserInfo = connectedUser
        self.userInfo.onNext(connectedUser)
        
        DispatchQueue.global(qos: .background).async {
            self.repoProvider.firestoreUserRepo.createUser(user: connectedUser) { result in
                switch result {
                case .success(let success):
                    print(success)
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
        }
    }
    
    func loadMyInfo() {
//        return Observable.create { [weak self] observer in
//            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestoreUserRepo.loadUser(userID: self.defaultUserInfo.id) { result in
                switch result {
                case .success(let entity):
                    guard let entity = entity else { return }
                    let imageURL = URL(string: entity.imageURL)
                    let user = User(id: entity.id, image: imageURL, nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
                    self.defaultUserInfo = user
                    self.userInfo.onNext(user)
//                    observer.onNext(user)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
//            return Disposables.create()
//        }
    }
    
    /// Fetch from Firebase
    @discardableResult
    func fetchUserInfo(user: User) -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestoreUserRepo.fetchUser(userID: user.id) { result in
                switch result {
                case .success(let entity):
                    guard let entity = entity else { return }
                    let imageURL = URL(string: entity.imageURL)
                    let user = User(id: entity.id, image: imageURL, nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
                    observer.onNext(user)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUserInfo(user: User, completion: @escaping (Bool) -> Void) {
        // Firebase에서 업데이트하기
        self.repoProvider.firestoreUserRepo.updateUser(user: user, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print(success)
                // Realm에서 업데이트하기
                self.repoProvider.realmUserRepo.updateUser(user: user)
                // Service에서 업데이트하기
                self.defaultUserInfo = user
                self.userInfo.onNext(self.defaultUserInfo)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    func updateUserImage(user: User, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        self.serviceProvider.repoProvider.firestorageImageRepo.updateUserImage(userID: user.id, image: profileImage) { result in
            switch result {
            case .success(let url):
                self.defaultUserInfo.image = url
                self.userInfo.onNext(self.defaultUserInfo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCookidRankers() -> Observable<[User]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestoreUserRepo.fetchCookidsRankers { result in
                switch result {
                case .success(let userEntities):
                    let users = userEntities.map { User(id: $0.id, image: URL(string: $0.imageURL), nickname: $0.nickname, determination: $0.determination, priceGoal: $0.priceGoal, userType: UserType(rawValue: $0.userType) ?? .preferDineIn, dineInCount: $0.dineInCount, cookidsCount: $0.cookidsCount) }
                    observer.onNext(users)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
}
