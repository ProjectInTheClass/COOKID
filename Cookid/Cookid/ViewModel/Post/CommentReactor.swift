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
        case addComment
        case commentContent(String)
    }
    
    enum Mutation {
        case setCommentContent(String)
        case setComments([Comment])
        case setUser(User)
    }
    
    struct State {
        var commentContent: String = ""
        var comments: [Comment] = []
        var user: User = DummyData.shared.singleUser
    }
    
    let initialState: State
    
    init(post: Post, commentService: CommentService, userService: UserService) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addComment:
            let newComment = Comment(commentID: UUID().uuidString, postID: post.postID, parentID: nil, user: self.currentState.user, content: self.currentState.commentContent, timestamp: Date(), didLike: false, subComments: nil, likes: 0)
            self.commentService.createComment(comment: newComment)
            return Observable.empty()
        case .commentContent(let content):
            return Observable.just(Mutation.setCommentContent(content))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let comments = commentService.fetchParentComments(post: post).map { Mutation.setComments($0) }
        let user = userService.user().map { Mutation.setUser($0) }
        return Observable.merge(mutation, comments, user)
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
        case .setCommentContent(let content):
            newState.commentContent = content
            return newState
        }
    }
   
}
