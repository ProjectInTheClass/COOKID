//
//  UserService.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/08.
//

import Foundation

class UserService {
    
    func loadUserInfo(userID: String, completion: @escaping (User) -> Void) {
        UserRepository.shared.fetchUserInfo(userID: userID) { userEntity in
            var users: User!
            
            for userEntity in userEntity {
                let userinfo = User(
                    nickname: userEntity.nickname,
                    determination: userEntity.determination,
                    priceGoal: userEntity.priceGoal,
                    userType: UserType(rawValue: userEntity.userType)!)
                users = userinfo
            }
            completion(users)
        }
    }
    
}
