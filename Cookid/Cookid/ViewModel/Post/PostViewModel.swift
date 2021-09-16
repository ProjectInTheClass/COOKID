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
        let postCellViewModel: Observable<[PostCellViewModel]>
        let user: Observable<User>
    }
    
    var input: Input
    var output: Output
    
    init(postService: PostService, userService: UserService, commentService: CommentService) {
        self.postService = postService
        self.userService = userService
        self.commentService = commentService

        let postCellViewModel = postService.fetchPosts()
            .map { posts -> [PostCellViewModel] in
                return posts.map { post -> PostCellViewModel in
                    return PostCellViewModel(postService: postService, userService: userService, commentService: commentService, post: post)
                }
            }
        
        let user = userService.user()
        
        self.input = Input()
        self.output = Output(postCellViewModel: postCellViewModel, user: user)
    }
    
}
