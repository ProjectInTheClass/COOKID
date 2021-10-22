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
        case setCommentSections([CommentSection])
        case setUser(User)
    }
    
    struct State {
        var commentContent: String = ""
        var commentSections: [CommentSection] = []
        var user: User = DummyData.shared.singleUser
    }
    
    let initialState: State
    
    init(post: Post, commentService: CommentService, userService: UserService) {
        print("Comment init")
        self.post = post
        self.commentService = commentService
        self.userService = userService
        
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        print("Comment mutate")
        switch action {
        case .addComment:
            let newComment = Comment(commentID: UUID().uuidString, postID: post.postID, parentID: nil, user: self.currentState.user, content: self.currentState.commentContent, timestamp: Date(), didLike: false, subComments: nil, likes: 0)
//            _ = self.commentService.createComment(comment: newComment)
            self.post.comments.append(newComment)
//            let newSections = fetchCommentSection(comments: post.comments)
            return Observable.empty()
        case .commentContent(let content):
            return Observable.just(Mutation.setCommentContent(content))
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        print("Comment transform")
        let user = userService.user().map { Mutation.setUser($0) }
        let commentsMutation = Observable.just(Mutation.setCommentSections(fetchCommentSection(comments: post.comments)))
        return Observable.merge(mutation, commentsMutation, user)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        print("Comment reduce")
        var newState = state
        switch mutation {
        case .setCommentSections(let commentSections):
            newState.commentSections = commentSections
            return newState
        case .setUser(let user):
            newState.user = user
            return newState
        case .setCommentContent(let content):
            newState.commentContent = content
            return newState
        }
    }
    
    typealias DataSource = RxTableViewSectionedReloadDataSource
    lazy var dataSource : DataSource<CommentSection> = {
        let datasource = DataSource<CommentSection> { _, tableView, indexPath, comment -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.commentCell, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.reactor = CommentCellReactor(post: self.post, comment: comment, commentService: self.commentService, userService: self.userService)
            return cell
        }
        return datasource
    }()
    
    func fetchCommentSection(comments: [Comment]) -> [CommentSection] {
        var commentSections = [CommentSection]()
        for i in comments where i.parentID == nil {
            var subComments = [Comment]()
            for j in comments where j.parentID == i.commentID {
                subComments.append(j)
            }
            let commentSection = CommentSection(header: i, items: subComments.sorted(by: { $0.timestamp < $1.timestamp }))
            commentSections.append(commentSection)
        }
        return commentSections.sorted(by: { $0.header.timestamp < $1.header.timestamp })
    }
   
}
