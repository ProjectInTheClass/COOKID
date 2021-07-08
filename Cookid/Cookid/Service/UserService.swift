//
//  UserService.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/08.
//

import Foundation

class UserService {
    
    static let shared = UserService()
    
    
    private let userRepository = UserRepository()
    
    func loadUserInfo(completion: @escaping (User) -> Void) {

        userRepository.fetchUserInfo { userentity in
            var user: User!
            for value in userentity {
                let userValue = User(
                                nickname: value.nickname,
                                determination: value.determination,
                                priceGoal: value.priceGoal,
                                userType: UserType(rawValue: value.userType)!)
                user = userValue
            }
            completion(user)
        }
    }
}
