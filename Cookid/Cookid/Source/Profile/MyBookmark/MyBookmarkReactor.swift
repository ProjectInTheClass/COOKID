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
    
    let initialState: State
    
    override init(serviceProvider: ServiceProviderType) {
        self.initialState = State()
        super.init(serviceProvider: serviceProvider)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let user = serviceProvider.userService.currentUser
        let userMutation = user.map { Mutation.setUser($0) }
        let fetchedPosts = Observable.merge(
            serviceProvider.postService.bookmaredTotalPosts,
            user.flatMap(serviceProvider.postService.fetchBookmarkedPosts(currentUser:)))
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
