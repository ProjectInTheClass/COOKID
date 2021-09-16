//
//  PostCellViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import RxSwift
import RxCocoa

class PostCellViewModel: ViewModelType {
    
    deinit {
        print("------> deinit cell viewModel")
    }
    
    let postService: PostService
    let commentService: CommentService
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        var post: Post
        let user: Driver<User>
        let comments: Driver<[Comment]>
    }
    
    var input: Input
    var output: Output
    
    init(postService: PostService, userService: UserService, commentService: CommentService, post: Post) {
        self.postService = postService
        self.userService = userService
        self.commentService = commentService
        
        let user = userService.user().asDriver(onErrorJustReturn: DummyData.shared.singleUser)
        let comments = commentService.fetchComments(postID: post.postID).asDriver(onErrorJustReturn: [])

        self.input = Input()
        self.output = Output(post: post, user: user, comments: comments)
    }
    
}
