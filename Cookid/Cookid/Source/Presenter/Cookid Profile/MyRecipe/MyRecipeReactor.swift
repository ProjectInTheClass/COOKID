//
//  MyRecipeReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/07.
//

import Foundation
import RxSwift
import ReactorKit

class MyRecipeReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutate {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    let userService: UserServiceType
    let postService: PostServiceType
    
    init(userService: UserServiceType,
         postService: PostServiceType) {
        self.userService = userService
        self.postService = postService
        self.initialState = State()
    }
}
