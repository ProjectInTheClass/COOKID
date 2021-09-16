//
//  PostViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import Foundation
import RxSwift

class PostViewModel: ViewModelType {
    
    let postService: PostService
    let commentService: CommentService
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Observable<[Post]>
        let user: Observable<User>
        let comments: Observable<[Comment]>
    }
    
    var input: Input
    var output: Output
    
    init(postService: PostService, userService: UserService, commentService: CommentService) {
        self.postService = postService
        self.userService = userService
        self.commentService = commentService

        let posts = postService.fetchPosts()
        let comments = commentService.fetchComments(postID: "")
        let user = userService.user()
        
        self.input = Input()
        self.output = Output(posts: posts, user: user, comments: comments)
    }
    
}
