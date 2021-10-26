//
//  CommentViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/25.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

// section -> Rx : rxdatasources -> header string = title
// section -> reactorKit : header / items -> rxdatasources
// Rx -> MV VM (멘붕) ?
// Repo -> entity 서버 통신 모델 commentEntity
// Service -> 로직 '모델' comment
// ViewModel -> 뷰 '모델' CommentSection

class CommentViewModel: ViewModelType, HasDisposeBag {
    
    let post: Post
    let commentService: CommentService
    let userService: UserService
    
    struct Input {
        // 일단 PublishRelay로 해보자.
        let commentContent = PublishSubject<String>()
        let uploadButtonTapped = PublishSubject<Void>()
        let subCommentButtonTapped = BehaviorSubject<Comment?>(value: nil)
    }
    
    struct Output {
        let user: Observable<User>
        let commentValidation = PublishRelay<Bool>()
        let uploadComment = PublishRelay<Void>()
        var onUpdated: (() -> Void)?
        var commentSections = [CommentSection]() {
            didSet {
                if let onUpdated = onUpdated {
                    onUpdated()
                }
            }
        }
    }
    
    var input: Input = Input()
    lazy var output: Output = Output(user: userService.user())
    
    init(post: Post, commentService: CommentService, userService: UserService) {
        self.post = post
        self.commentService = commentService
        self.userService = userService
        
        // 모든 저장 프로퍼티가 초기화가 되어 있어야 함수도 사용할 수 있다.
        input.commentContent
            .distinctUntilChanged()
            .map(commentValidationCheck)
            .bind(to: output.commentValidation)
            .disposed(by: disposeBag)
        
        input.uploadButtonTapped
            .withLatestFrom(
                Observable.combineLatest(
                    input.subCommentButtonTapped,
                userService.user(),
                input.commentContent))
            .bind { [weak self] comment, user, content in
                guard let self = self else { return }
                if let comment = comment {
                    self.uploadSubComment(user: user, content: content, parentComment: comment)
                } else {
                    self.uploadComment(user: user, content: content)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func commentValidationCheck(_ text: String) -> Bool {
        return !text.isEmpty && text != "" && text.count > 1
    }
    
    func uploadSubComment(user: User, content: String, parentComment: Comment) {
        let newComment = Comment(commentID: UUID().uuidString,
                                 postID: post.postID,
                                 parentID: parentComment.commentID,
                                 user: user,
                                 content: content,
                                 timestamp: Date(),
                                 didLike: false,
                                 subComments: nil,
                                 likes: 0)
        if let index = output.commentSections.firstIndex(where: { section in
            return section.header.commentID == parentComment.commentID
        }) {
            commentService.createComment(comment: newComment)
            output.commentSections[index].items.append(newComment)
        }
    }
    
    func uploadComment(user: User, content: String) {
        let newComment = Comment(commentID: UUID().uuidString,
                                 postID: post.postID,
                                 parentID: nil,
                                 user: user,
                                 content: content,
                                 timestamp: Date(),
                                 didLike: false,
                                 subComments: nil,
                                 likes: 0)
        let newSection = CommentSection(header: newComment, items: [])
        output.commentSections.append(newSection)
        commentService.createComment(comment: newComment)
    }
    
    func fetchComments() {
        commentService.fetchComments(post: post) { [weak self] comments in
            guard let self = self else { return }
            self.output.commentSections = self.fetchCommentSection(comments: comments)
        }
    }
    
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
