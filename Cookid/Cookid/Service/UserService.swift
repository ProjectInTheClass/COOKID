//
//  UserService.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/08.
//

import Foundation
import RxSwift
import RxCocoa

class UserService {
    
    /// Fetch from Realm
    private var defaultUserInfo = RealmUserRepo.instance.fetchUser().map { userentity -> User in
        return User(id: userentity.id.stringValue, nickname: userentity.nickName, determination: userentity.determination, priceGoal: userentity.goal, userType: UserType(rawValue: userentity.type) ?? .preferDineIn)
    } ?? DummyData.shared.singleUser
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    
    private var userSortedArr = [UserForRanking]()
    private lazy var userSorted = BehaviorSubject<[UserForRanking]>(value: userSortedArr)
    
    /// Fetch from Firebase
    func loadUserInfo(completion: @escaping (User?) -> Void) {
        FirestoreUserRepo.instance.fetchUser(userID: defaultUserInfo.id) { user in
            if let user = user {
                self.defaultUserInfo = user
                self.userInfo.onNext(user)
                completion(user)
            } else {
                print("fetch User Error")
                completion(nil)
            }
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
    func connectUserInfo(localUser: LocalUser, imageURL: URL?) {
        
        let connectedUser = User(id: localUser.id.stringValue, image: imageURL, nickname: localUser.nickName, determination: localUser.determination, priceGoal: localUser.goal, userType: UserType(rawValue: localUser.type) ?? .preferDineIn, dineInCount: 0, cookidsCount: 0)
        
        FirestoreUserRepo.instance.createUser(user: connectedUser) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.defaultUserInfo = connectedUser
                self.userInfo.onNext(self.defaultUserInfo)
            }
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
    
    func uploadUserImage(user: User, image: UIImage?) -> Observable<URL?> {
        return Observable.create { observer in
            FirestoreUserRepo.instance.uploadUserImage(user: user, image: image) { url in
                observer.onNext(url)
            }
            return Disposables.create()
        }
    }
    
    func user() -> Observable<User> {
        return userInfo
    }
    
    func sortedUsers() -> Observable<[UserForRanking]> {
        return userSorted
    }
    
    
}
