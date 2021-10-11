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
        case heartButtonTapped(Bool)
        case bookmarkButtonTapped(Bool)
    }
    
    enum Mutation {
        case setHeart(Bool)
        case setHeartCount(Int)
        case setBookmark(Bool)
        case setBookmarkCount(Int)
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
    
    init(post: Post, postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        self.initialState = State(post: post, isHeart: post.didLike, isBookmark: post.didCollect, heartCount: post.likes, bookmarkCount: post.collections)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let comment = commentService.fetchComments(post: self.currentState.post).map { Mutation.setComments($0) }
        let user = userService.user().map { Mutation.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
}
