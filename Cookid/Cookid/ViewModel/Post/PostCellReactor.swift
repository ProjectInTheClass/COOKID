//
//  PostCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class PostCellReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    let commentService: CommentService
    
    enum Action {
        case heartbuttonTapped(Bool, Int)
        case bookmarkButtonTapped(Bool, Int)
    }
    
    enum Mutation {
        case setHeart(Bool, Int)
        case setBookmark(Bool, Int)
        case setUser(User)
        case setComments([Comment])
    }
    
    struct State {
        var post: Post
        var isHeart: Bool
        var isBookmark: Bool
        var heartCount: Int
        var bookmarkCount: Int
        var user: User = DummyData.shared.singleUser
        var comments: [Comment] = []
    }
    
    let initialState: State
    
    init(post: Post, postService: PostService, userService: UserService, commentService: CommentService) {
        self.postService = postService
        self.userService = userService
        self.commentService = commentService
        
        self.initialState = State(post: post, isHeart: post.didLike, isBookmark: post.didCollect, heartCount: post.likes, bookmarkCount: post.collections)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let comment = commentService.fetchComments(post: self.currentState.post).map { Mutation.setComments($0) }
        let user = userService.user().map { Mutation.setUser($0) }
        return Observable.merge(comment, user)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .heartbuttonTapped(let heartValue):
            return Observable.just(Mutation.setHeart(heartValue.0, heartValue.1))
        case .bookmarkButtonTapped(let BookmarkValue):
            return Observable.just(Mutation.setBookmark(BookmarkValue.0, BookmarkValue.1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setComments(let comments):
            newState.comments = comments
            return newState
        case .setUser(let user):
            newState.user = user
            return newState
        case .setHeart(let isHeart):
            newState.isHeart = isHeart.0
            newState.heartCount = isHeart.1
            return newState
        case .setBookmark(let isBookmark):
            newState.isBookmark = isBookmark.0
            newState.bookmarkCount = isBookmark.1
            return newState
        }
    }
    
}
