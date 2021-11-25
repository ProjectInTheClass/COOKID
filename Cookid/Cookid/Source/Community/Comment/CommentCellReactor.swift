//
//  CommentCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/10.
//

import Foundation
import RxSwift
import ReactorKit

class CommentCellReactor: Reactor {
  
    enum Action {
    }
    
    enum Mutation {
        case setUser(User)
    }
    
    struct State {
        var user: User = DummyData.shared.singleUser
        var comment: Comment
        var post: Post
    }
    
    let initialState: State
    let serviceProvider: ServiceProviderType
    
    init(post: Post, comment: Comment, serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        self.initialState = State(comment: comment, post: post)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = serviceProvider.userService.currentUser
            .map { Mutation.setUser($0) }
        return .merge(mutation, user)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUser(let user):
            newState.user = user
            return newState
        }
    }
    
}
