//
//  UserInfoUpdateViewModel.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/14.
//

import Foundation

class UserInfoUpdateViewModel {
    
    let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func updateUser(user: User){
        userService.updateUserInfo(user: user)
    }
    
}
