//
//  MyBookmarkCollectionViewCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/06.
//

import Foundation
import ReactorKit

class MyBookmarkCollectionViewCellReactor: Reactor {
   
    enum Action {
        case heartButtonTapped(Bool)
        case bookmarkButtonTapped(Bool)
    }
    
    enum Mutation {
        case setHeart(Bool)
        case setBookmark(Bool)
        case setUser(User)
    }
    
    struct State {
        var post: Post
        var isHeart: Bool
        var isBookmark: Bool
        var user: User = DummyData.shared.singleUser
    }
    
    let initialState: State
    let serviceProvider: ServiceProviderType
    
    init(post: Post, serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        self.initialState = State(post: post, isHeart: post.didLike, isBookmark: post.didCollect)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = serviceProvider.userService.currentUser
            .map { Mutation.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
}
