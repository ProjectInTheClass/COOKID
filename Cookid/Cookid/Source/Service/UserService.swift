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
    var currentUser: BehaviorSubject<User> { get }
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
                    image: nil,
                    nickname: userentity.nickName,
                    determination: userentity.determination,
                    priceGoal: userentity.goal,
                    userType: UserType(rawValue: userentity.type) ?? .preferDineIn,
                    dineInCount: 0,
                    cookidsCount: 0)
    }!
    
    lazy var currentUser = BehaviorSubject<User>(value: defaultUserInfo)
    
    /// Create in Realm
    func creatUser(user: User, completion: @escaping (Bool) -> Void) {
        self.repoProvider.realmUserRepo.createUser(user: user) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.defaultUserInfo = user
                self.currentUser.onNext(self.defaultUserInfo)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Upload at Firebase with Local User
    func connectUser(localUser: LocalUser, imageURL: URL?, dineInCount: Int, cookidsCount: Int, completion: @escaping (Bool) -> Void) {
        let connectedUser = User(id: localUser.id.stringValue, image: imageURL, nickname: localUser.nickName, determination: localUser.determination, priceGoal: localUser.goal, userType: UserType(rawValue: localUser.type) ?? .preferDineIn, dineInCount: dineInCount, cookidsCount: cookidsCount)
        self.defaultUserInfo = connectedUser
        self.currentUser.onNext(connectedUser)
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
    
    /// Fetch from Firebase
    func loadMyInfo() {
        self.repoProvider.firestoreUserRepo.fetchUser(userID: self.defaultUserInfo.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):
                guard let entity = entity else { return }
                let user = self.convertEntityToUser(entity: entity)
                self.defaultUserInfo = user
                self.currentUser.onNext(user)
            case .failure(let error):
                print(error.rawValue)
            }
        }
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
                    let user = self.convertEntityToUser(entity: entity)
                    observer.onNext(user)
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUserInfo(user: User, completion: @escaping (Bool) -> Void) {
        // Realm에서 업데이트하기
        self.repoProvider.realmUserRepo.updateUser(user: user) { [weak self] success in
            guard let self = self else { return }
            if success {
                // Memory에서 업데이트하기
                self.defaultUserInfo = user
                self.currentUser.onNext(self.defaultUserInfo)
                // Firebase에서 업데이트하기
                self.repoProvider.firestoreUserRepo.updateUser(user: user, completion: { result in
                    switch result {
                    case .success(let success):
                        print(success)
                        completion(true)
                    case .failure(let error):
                        print(error)
                        completion(true)
                    }
                })
            } else {
                completion(false)
            }
        }
        
    }
    
    func updateUserImage(user: User, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        self.serviceProvider.repoProvider.firestorageImageRepo.uploadUserImage(userID: user.id, image: profileImage) { result in
            switch result {
            case .success(let url):
                self.defaultUserInfo.image = url
                self.currentUser.onNext(self.defaultUserInfo)
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
                    let users = userEntities.map { self.convertEntityToUser(entity: $0) }
                    observer.onNext(users)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
}
