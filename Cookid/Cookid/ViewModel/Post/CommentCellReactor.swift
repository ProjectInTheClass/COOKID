//
//  CommentCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/10.
//

import Foundation
import RxSwift
import ReactorKit

final class CommentCellReactor: Reactor {
    
    let commentService: CommentService
    let userService: UserService
    
    enum Action {
        case delete
        case report
        case reply
    }
    
    enum Mutation {
        case deleteComment
        case reportComment
        case setUser(User)
        case subComments([Comment])
    }
    
    struct State {
        var post: Post
        var comment: Comment
        var user: User = DummyData.shared.singleUser
        var subComments: [Comment] = []
    }
    
    let initialState: State
    
    init(post: Post, comment: Comment, commentService: CommentService, userService: UserService) {
        self.commentService = commentService
        self.userService = userService
        self.initialState = State(post: post, comment: comment)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .delete:
            commentService.deleteComment(comment: self.currentState.comment)
            return Observable.just(Mutation.deleteComment)
        case .report:
            commentService.reportComment(comment: self.currentState.comment)
            return Observable.just(Mutation.reportComment)
        case .reply:
            let subComments = commentService.fetchSubComment(postID: self.currentState.post.postID, commentID: self.currentState.comment.commentID)
            return subComments.map { Mutation.subComments($0) }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let user = userService.user().map { Mutation.setUser($0) }
        return Observable.merge(mutation, user)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUser(let user):
            newState.user = user
            return newState
        case .deleteComment:
            return newState
        case .reportComment:
            return newState
        case .subComments(let subComments):
            newState.subComments = subComments
            return newState
        }
    }
}
