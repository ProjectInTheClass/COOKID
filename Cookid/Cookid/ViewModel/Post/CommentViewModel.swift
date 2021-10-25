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

class CommentViewModel: ViewModelType, HasDisposeBag {
    
    let commentService: CommentService
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        var post: Post
        var onUpdated: (() -> Void)?
        var commentSections = [CommentSection]() {
            didSet {
                if let onUpdated = onUpdated {
                    onUpdated()
                }
            }
        }
    }
    
    var input: Input
    var output: Output
    
    init(post: Post, commentService: CommentService, userService: UserService) {
        self.commentService = commentService
        self.userService = userService
        
        self.input = Input()
        self.output = Output(post: post)
    }
    
    func uploadComment() {
        print("✅ 업로드 버튼이 클릭되었습니다.")
    }
    
    func fetchComments() {
        commentService.fetchComments(post: output.post) { [weak self] comments in
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
