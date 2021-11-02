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

class MyPostReactor: BaseViewModel, Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        case setMyPosts([Post])
        case setUser(User)
    }
    
    struct State {
        var user: User = DummyData.shared.singleUser
        var myPosts: [Post] = []
    }
    
    let initialState: State
    
    override init(serviceProvider: ServiceProviderType) {
        self.initialState = State()
        super.init(serviceProvider: serviceProvider)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.user()
        let userMutation = user.map { Mutation.setUser($0) }
        let fetchMyPosts = Observable.merge(postService.myTotalPosts, user.flatMap(postService.fetchMyPosts(user:))).map { Mutation.setMyPosts($0) }
        return Observable.merge(mutation, userMutation, fetchMyPosts)
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
        }
    }
    
}
