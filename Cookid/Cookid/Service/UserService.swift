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
    static let shared = UserService()
    
    private let userRepository = UserRepository()
    
    private var defaultUserInfo =  User(userID: "", nickname: "비회원", determination: "유저 정보를 입력한 후에 사용해 주세요.", priceGoal: "0", userType: .preferDineIn)
    
    private lazy var userInfo = BehaviorSubject<User>(value: defaultUserInfo)
    
    func loadUserInfo(completion: @escaping (User)->Void) {
        self.userRepository.fetchUserInfo { [unowned self] userentity in
            let user = User(userID: userentity.userId, nickname: userentity.nickname, determination: userentity.determination, priceGoal: userentity.priceGoal, userType: UserType(rawValue: userentity.userType)!)
            defaultUserInfo = user
            self.userInfo.onNext(user)
        }
    }
    
    func user() -> Observable<User> {
        return userInfo
    }
    
    
    func updateUserInfo(user: User) {
        userRepository.updateUserInfo(user: user)
    }
    
    func deleteUser(){
        userRepository.deleteUser()
    }
}
