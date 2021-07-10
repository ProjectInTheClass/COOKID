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
    
    var currentUser: User {
        return loadCurrentUser()
    }
    
    func loadUserInfo(completion: @escaping (User) -> Void) {
        userRepository.fetchUserInfo { userentity in
            
            let user = User(nickname: userentity.nickname, determination: userentity.determination, priceGoal: userentity.priceGoal, userType: UserType(rawValue: userentity.userType)!)
            
            completion(user)
        }
    }
    
    func loadCurrentUser() -> User {
        
        var newUser: User?
        
        loadUserInfo { user in
            newUser = user
        }
        
        return newUser ?? User(userID: "", nickname: "", determination: "", priceGoal: "", userType: .preferDineIn)
        
    }
}
