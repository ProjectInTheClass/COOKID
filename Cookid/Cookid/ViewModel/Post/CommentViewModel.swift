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
        _ = input.commentContent
            .distinctUntilChanged()
            .map(commentValidationCheck)
            .bind(to: output.commentValidation)
            .disposed(by: disposeBag)
        
        _ = input.uploadButtonTapped
            .withLatestFrom(
                Observable.combineLatest(
                    userService.user(),
                    input.commentContent))
            .bind(onNext: { user, content in
                self.uploadComment(user: user, content: content)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func commentValidationCheck(_ text: String) -> Bool {
        return !text.isEmpty && text != "" && text.count > 1
    }
    
    func uploadComment(user: User, content: String) {
        let newComment = Comment(commentID: UUID().uuidString,
                                 postID: post.postID, parentID: nil,
                                 user: user, content: content, timestamp: Date(),
                                 didLike: false, subComments: nil, likes: 0)
        commentService.createComment(comment: newComment)
        let newSection = CommentSection(header: newComment, items: [])
        output.commentSections.append(newSection)
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
