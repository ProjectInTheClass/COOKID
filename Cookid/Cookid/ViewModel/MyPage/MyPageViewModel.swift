//
//  MyPageViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModelType {
    
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        let userInfo: Observable<User>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService) {
        self.userService = userService
        
        userService.loadUserInfo { _ in }
        
        let userInfo = userService.user()
        
        self.input = Input()
        self.output = Output(userInfo: userInfo)
    }
}
