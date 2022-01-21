//
//  MyPostTableViewCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyPostTableViewCellReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        case setUser(User)
    }
    
    struct State {
        var post: Post
        var user: User = DummyData.shared.singleUser
    }
    
    let initialState: State
    let userService: UserServiceType
    init(post: Post,
         userService: UserServiceType) {
        self.userService = userService
        self.initialState = State(post: post)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = self.userService.currentUser.map { Mutation.setUser($0) }
        return Observable.merge(mutation, user)
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
