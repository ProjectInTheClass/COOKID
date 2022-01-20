//
//  MyPostReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyPostReactor: Reactor {
    
    enum Action {
        case deletePost(Post)
    }
    
    enum Mutation {
        case setMyPosts([Post])
        case setUser(User)
        case setIsError(Bool)
    }
    
    struct State {
        var user: User = DummyData.shared.singleUser
        var myPosts: [Post] = []
        var isError: Bool?
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
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.currentUser
        let userMutation = user.map { Mutation.setUser($0) }
        let totalMyPosts = postService.myTotalPosts
            .map { Mutation.setMyPosts($0) }
        let fetchMyPosts =
            user.flatMap(postService.fetchMyPosts)
            .map { Mutation.setMyPosts($0) }
        return Observable.merge(mutation, totalMyPosts, userMutation, fetchMyPosts)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .deletePost(let post):
            return self.postService.deletePost(post: post)
                .map { Mutation.setIsError(!$0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUser(let user):
            newState.user = user
            return newState
        case .setMyPosts(let myPosts):
            newState.myPosts = myPosts
            return newState
        case .setIsError(let isError):
            newState.isError = isError
            return newState
        }
    }
    
}
