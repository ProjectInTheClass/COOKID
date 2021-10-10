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
        
    }
    
    enum Mutation {
        case setUser(User)
        case setPosts([Post])
    }
    
    struct State {
        var bookmarkPosts: [Post] = []
        var user: User = DummyData.shared.singleUser
    }
    
    init(postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let user = userService.user()
        let userMutation = user.map { Mutation.setUser($0) }
        let fetchedPosts = Observable.merge(postService.bookmaredTotalPosts, user.flatMap(postService.fetchBookmarkedPosts(user:))).map { Mutation.setPosts($0) }
        return Observable.merge(mutation, userMutation, fetchedPosts)
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
        }
    }
    
}
