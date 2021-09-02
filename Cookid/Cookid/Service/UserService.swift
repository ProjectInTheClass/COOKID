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
    
    let userRepository: UserRepository
    
    private var defaultUserInfo =  User(userID: "", nickname: "비회원", determination: "유저 정보를 입력한 후에 사용해 주세요.", priceGoal: 0, userType: .preferDineIn)
    
    private var userSortedArr = [UserForRanking]()
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    private lazy var userSorted = BehaviorSubject<[UserForRanking]>(value: userSortedArr)
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func loadUserInfo(completion: @escaping (User) -> Void) {
        //        self.userRepository.fetchUserInfo { [unowned self] userentity in
        //            let user = User(userID: userentity.userId, nickname: userentity.nickname, determination: userentity.determination, priceGoal: userentity.priceGoal, userType: UserType(rawValue: userentity.userType) ?? .preferDineIn)
        //            defaultUserInfo = user
        //            self.userInfo.onNext(user)
        //            completion(user)
        //        }
        guard let userentity = RealmUserRepo.instance.fetchUser() else { return }
        let user = User(userID: userentity.id.stringValue, nickname: userentity.nickName, determination: userentity.determination, priceGoal: userentity.goal, userType: UserType(rawValue: userentity.type) ?? .preferDineIn)
        defaultUserInfo = user
        self.userInfo.onNext(user)
    }
    
    func sortedUsers() -> Observable<[UserForRanking]> {
        return userSorted
    }
    
    func user() -> Observable<User> {
        return userInfo
    }
    
    func uploadUserInfo(user: User) {
        userRepository.uploadUserInfo(userInfo: user)
        defaultUserInfo = user
        userInfo.onNext(defaultUserInfo)
    }
    
    func updateUserInfo(user: User, completion: @escaping ((Bool) -> Void)) {
        userRepository.updateUserInfo(user: user)
        completion(true)
        self.defaultUserInfo = user
        self.userInfo.onNext(user)
    }
    
    func makeRanking(completion: @escaping ([UserForRanking]?, Error?) -> Void) {
        
        userRepository.fetchUsers { allEntities in
            
            let allUserSotred = allEntities.map { userAllEntity -> UserForRanking in
                
                let nickName = userAllEntity.user.nickname
                let determination = userAllEntity.user.determination
                let userType = UserType(rawValue: userAllEntity.user.userType)!
                let sum = userAllEntity.totalCount
                
                return UserForRanking(nickname: nickName, userType: userType, determination: determination, groceryMealSum: sum)
            }.sorted { user1, user2 in
                user1.groceryMealSum > user2.groceryMealSum
            }[0...29]
            
            let rankingArray = Array(allUserSotred).filter { $0.groceryMealSum > 0 }
            
            self.userSortedArr = rankingArray
            self.userSorted.onNext(rankingArray)
            completion(rankingArray, nil)
        }
    }
}
