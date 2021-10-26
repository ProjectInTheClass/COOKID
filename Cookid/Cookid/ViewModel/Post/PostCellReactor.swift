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
    
    let sender: UIViewController
    let postService: PostService
    let userService: UserService
    let commentService: CommentService
    
    enum Action {
        case heartbuttonTapped(Bool)
        case bookmarkButtonTapped(Bool)
    }
    
    enum Mutation {
        case setHeart(Bool)
        case setHeartCount(Int)
        case setBookmark(Bool)
        case setBookmarkCount(Int)
        case setUser(User)
    }
    
    struct State {
        var post: Post
        var isHeart: Bool
        var isBookmark: Bool
        var heartCount: Int
        var bookmarkCount: Int
        var user: User = DummyData.shared.singleUser
    }
    
    let initialState: State
    
    init(sender: UIViewController, post: Post, postService: PostService, userService: UserService, commentService: CommentService) {
        self.postService = postService
        self.userService = userService
        self.commentService = commentService
        self.sender = sender
        
        self.initialState = State(post: post, isHeart: post.didLike, isBookmark: post.didCollect, heartCount: post.likes, bookmarkCount: post.collections)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.user().map { Mutation.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        let post = self.currentState.post
        let user = self.currentState.user
        
        switch action {
        case .heartbuttonTapped(let isHeart):
            self.postUpdateByHeart(post: post, isHeart: isHeart)
            self.postService.heartTransaction(sender: self.sender, user: user, post: post, isHeart: isHeart)
            return Observable.concat([
                Observable.just(Mutation.setHeart(isHeart)),
                Observable.just(Mutation.setHeartCount(self.currentState.post.likes))])
        case .bookmarkButtonTapped(let isBookmark):
            self.postUpdateByBookmark(post: post, isBookmark: isBookmark)
            self.postService.bookmarkTransaction(sender: self.sender, user: user, post: post, isBookmark: isBookmark)
            return Observable.concat([
                Observable.just(Mutation.setBookmark(isBookmark)),
                Observable.just(Mutation.setBookmarkCount(self.currentState.post.collections))])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUser(let user):
            newState.user = user
            return newState
        case .setHeart(let isHeart):
            newState.isHeart = isHeart
            return newState
        case .setBookmark(let isBookmark):
            newState.isBookmark = isBookmark
            return newState
        case .setHeartCount(let heartCount):
            newState.heartCount = heartCount
            return newState
        case .setBookmarkCount(let bookmarkCount):
            newState.bookmarkCount = bookmarkCount
            return newState
        }
    }
    
    func postUpdateByHeart(post: Post, isHeart: Bool) {
        if isHeart {
            post.likes += 1
            post.didLike = isHeart
        } else {
            post.likes -= 1
            post.didLike = isHeart
        }
    }
    
    func postUpdateByBookmark(post: Post, isBookmark: Bool) {
        if isBookmark {
            post.collections += 1
            post.didCollect = isBookmark
        } else {
            post.collections -= 1
            post.didCollect = isBookmark
        }
    }
}
