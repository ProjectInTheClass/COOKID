//
//  MyBookmarkReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/05.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

class MyBookmarkReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    let initialState: State
    
    enum Action {
        case loadNextPart
    }
    
    enum Mutation {
        case setPosts([Post])
        case appendPosts([Post])
        case setLoadingNextPart(Bool)
    }
    
    struct State {
        var bookmarkPosts: [Post] = []
        var isLoadingNextPart: Bool = false
    }
    
    init(postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        
        self.initialState = State()
    }
    
}
