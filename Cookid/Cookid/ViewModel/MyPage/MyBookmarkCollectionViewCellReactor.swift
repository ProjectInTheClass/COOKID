//
//  MyBookmarkCollectionViewCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/06.
//

import Foundation
import ReactorKit

class MyBookmarkCollectionViewCellReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    
    enum Action {
        case heartTapped
    }
    
    enum Mutation {
        case setIsHeart(Bool)
    }
    
    struct State {
        let post: Post
        var isHeart: Bool
    }
    
    let initialState: State
    
    init(post: Post, postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        self.initialState = State(post: post, isHeart: post.didLike)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .heartTapped:
            let isSelect = !self.currentState.isHeart
            self.postService.heartTransaction(isSelect: isSelect)
            return Observable.just(Mutation.setIsHeart(isSelect))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsHeart(let isSelect):
            newState.isHeart = isSelect
            return newState
        }
    }
}
