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
    
    /// Fetch from Realm
    private var defaultUserInfo = RealmUserRepo.instance.fetchUser().map { userentity -> User in
        return User(id: userentity.id.stringValue, image: UIImage(systemName: "")?.withTintColor(.darkGray), nickname: userentity.nickName, determination: userentity.determination, priceGoal: userentity.goal, userType: UserType(rawValue: userentity.type) ?? .preferDineIn)
    } ?? DummyData.shared.singleUser
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    
    private var userSortedArr = [UserForRanking]()
    private lazy var userSorted = BehaviorSubject<[UserForRanking]>(value: userSortedArr)
    
    /// Fetch from Firebase
    func loadUserInfo(completion: @escaping (User?) -> Void) {
        FirestoreUserRepo.instance.fetchUser(userID: defaultUserInfo.id) { userEntity in
            if let entity = userEntity {
                guard let url = entity.imageURL else { return }
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let imageResult):
                        let userImage = imageResult.image
                        let user = User(id: entity.id, image: userImage, nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
                        self.defaultUserInfo = user
                        self.userInfo.onNext(user)
                        completion(user)
                    case .failure(let error):
                        print(error)
                    }
                }
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
    func connectUserInfo(localUser: LocalUser, imageURL: URL?, dineInCount: Int, cookidsCount: Int, completion: @escaping (Bool) -> Void) {
        guard let imageURL = imageURL else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
            case .success(let image):
                let connectedUser = User(id: localUser.id.stringValue, image: image.image, nickname: localUser.nickName, determination: localUser.determination, priceGoal: localUser.goal, userType: UserType(rawValue: localUser.type) ?? .preferDineIn, dineInCount: dineInCount, cookidsCount: cookidsCount)
                self.defaultUserInfo = connectedUser
                self.userInfo.onNext(self.defaultUserInfo)
                completion(true)
                
                DispatchQueue.global(qos: .background).async {
                    FirestoreUserRepo.instance.createUser(user: connectedUser) { _ in }
                }
                
            case .failure(_):
                print("kingfisher - connectUserInfo - error")
                completion(false)
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
    
    func user() -> Observable<User> {
        return userInfo
    }
    
    func sortedUsers() -> Observable<[UserForRanking]> {
        return userSorted
    }
    
    
}
