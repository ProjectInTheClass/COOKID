//
//  CommentReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/21.
//

import Foundation
import RxSwift
import ReactorKit
import RxDataSources

// 다시 짜기
final class CommentReactor: Reactor {
    
    let post: Post
    let commentService: CommentService
    let userService: UserService
    
    enum Action {
        
    }
    
    enum Mutation {
        case setComments([Comment])
    }
    
    struct State {
        var comments: [Comment] = []
    }
    
    let initialState: State
    
    init(post: Post, commentService: CommentService, userService: UserService) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let comments = commentService.fetchParentComments(post: post).map { Mutation.setComments($0) }
        return Observable.merge(mutation, comments)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setComments(let comments):
            newState.comments = comments
            return newState
        }
    }
   
}
