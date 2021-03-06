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
import FirebaseAnalytics

class CommentViewModel: ViewModelType, HasDisposeBag {
    
    let post: Post
    
    struct Input {
        let commentContent = PublishSubject<String>()
        let uploadButtonTapped = PublishSubject<Void>()
        let subCommentButtonTapped = BehaviorSubject<Comment?>(value: nil)
        let deleteButtonTapped = PublishSubject<Comment>()
        let reportButtonTapped = PublishSubject<Comment>()
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
    lazy var output: Output = Output(
        user: self.userService.currentUser)
    
    let userService: UserServiceType
    let commentService: CommentServiceType
    
    init(post: Post,
         userService: UserServiceType,
         commentService: CommentServiceType
    ) {
        self.userService = userService
        self.commentService = commentService
        self.post = post
        
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
                    output.user,
                input.commentContent))
            .bind { [weak self] comment, user, content in
                Analytics.logEvent("addCommentButton_tap", parameters: nil)
                guard let self = self else { return }
                if let comment = comment {
                    self.uploadSubComment(user: user, content: content, parentComment: comment)
                } else {
                    self.uploadComment(user: user, content: content)
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .bind(onNext: { owner, comment in
                owner.deleteComment(comment)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.reportButtonTapped,
            output.user)
            .bind(onNext: { [weak self] comment, user in
                guard let self = self else { return }
                self.reportComment(comment, user)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func commentValidationCheck(_ text: String) -> Bool {
        return !text.isEmpty && text != "" && text.count > 1
    }
    
    func deleteComment(_ comment: Comment) {
        if let parentID = comment.parentID {
            guard let index = output.commentSections.firstIndex(where: { section in
                return section.header.commentID == parentID }) else { return }
            guard let subIndex = output.commentSections[index].items.firstIndex(where: { subComment in
                return subComment.commentID == comment.commentID }) else { return }
            
            output.commentSections[index].items.remove(at: subIndex)
            self.commentService.deleteComment(comment: comment)
        } else {
            guard let index = output.commentSections.firstIndex(where: { section in
                return section.header.commentID == comment.commentID
            }) else { return }
            
            output.commentSections[index].items.removeAll()
            output.commentSections.remove(at: index)
            self.commentService.deleteComment(comment: comment)
        }
    }
    
    func reportComment(_ comment: Comment, _ user: User) {
        if let parentID = comment.parentID {
            guard let index = output.commentSections.firstIndex(where: { section in
                return section.header.commentID == parentID }) else { return }
            guard let subIndex = output.commentSections[index].items.firstIndex(where: { subComment in
                return subComment.commentID == comment.commentID }) else { return }
            
            output.commentSections[index].items.remove(at: subIndex)
            self.commentService.reportComment(comment: comment, currentUser: user)
        } else {
            guard let index = output.commentSections.firstIndex(where: { section in
                return section.header.commentID == comment.commentID
            }) else { return }
            
            output.commentSections[index].items.removeAll()
            output.commentSections.remove(at: index)
            self.commentService.reportComment(comment: comment, currentUser: user)
        }
    }
    
    func uploadSubComment(user: User, content: String, parentComment: Comment) {
                let newComment = Comment(commentID: UUID().uuidString,
                                 postID: post.postID,
                                 parentID: parentComment.commentID,
                                 user: user,
                                 content: content,
                                 timestamp: Date(),
                                 didLike: false,
                                 likes: 0)
        if let index = output.commentSections.firstIndex(where: { section in
            return section.header.commentID == parentComment.commentID
        }) {
            self.commentService.createComment(comment: newComment)
            output.commentSections[index].isOpened = true
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
                                 likes: 0)
        let newSection = CommentSection(header: newComment, items: [])
        output.commentSections.append(newSection)
        self.commentService.createComment(comment: newComment)
    }
    
    func fetchComments(user: User) {
        self.commentService.fetchComments(post: post, currentUser: user) { [weak self] comments in
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
