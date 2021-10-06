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
        case userSetting
        case fetchBookmarkPosts
        case loadNextPart
    }
    
    enum Mutation {
        case setUser(User)
        case setPosts([Post])
        case appendPosts([Post])
        case setLoadingNextPart(Bool)
    }
    
    struct State {
        var bookmarkPosts: [Post] = []
        var isLoadingNextPart: Bool = false
        var user: User = DummyData.shared.singleUser
    }
    
    init(postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchBookmarkPosts:
            let user = self.currentState.user
            return Observable<Mutation>.concat([
                Observable.just(Mutation.setLoadingNextPart(true)),
                self.postService.fetchBookmarkedPosts(user: user).map { Mutation.setPosts($0) },
                Observable.just(Mutation.setLoadingNextPart(false))
            ])
        case .userSetting:
            return self.userService.user().map { Mutation.setUser($0) }
        case .loadNextPart:
            // fetch posts
            return Observable.just(Mutation.appendPosts([]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPosts(let bookmarkedPosts):
            newState.bookmarkPosts = bookmarkedPosts
            return newState
        case .setUser(let user):
            newState.user = user
            return newState
        case .appendPosts(let posts):
            // 이건 어떻게 그냥 안해도 될 것같음
            newState.bookmarkPosts.append(contentsOf: posts)
            return newState
        case .setLoadingNextPart(let isLoading):
            newState.isLoadingNextPart = isLoading
            return newState
        }
    }
    
}
