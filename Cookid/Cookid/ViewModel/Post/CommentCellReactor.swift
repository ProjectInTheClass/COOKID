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
    
    let userService: UserService

    enum Action {
    }
    
    enum Mutation {
        case setUser(User)
    }
    
    struct State {
        var user: User = DummyData.shared.singleUser
        var comment: Comment
    }
    
    let initialState: State
    
    init(comment: Comment, userService: UserService) {
        self.userService = userService
        self.initialState = State(comment: comment)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.user().map { Mutation.setUser($0) }
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
