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

class MyBookmarkReactor: BaseViewModel, Reactor {
    
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
    
    let userService: UserServiceType
    let postService: PostServiceType
    let initialState: State
    
    init(userService: UserServiceType,
         postService: PostServiceType) {
        self.userService = userService
        self.postService = postService
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let user = self.userService.currentUser
        let userMutation = user.map { Mutation.setUser($0) }
        let fetchedPosts = Observable.merge(
            self.postService.bookmaredTotalPosts,
            user.flatMap(self.postService.fetchBookmarkedPosts(currentUser:)))
            .map { Mutation.setPosts($0) }
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
