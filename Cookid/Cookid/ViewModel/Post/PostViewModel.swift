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
    let userService: UserService
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Observable<[Post]>
    }
    
    var input: Input
    var output: Output
    
    init(postService: PostService, userService: UserService) {
        self.postService = postService
        self.userService = userService
        
        let posts = postService.fetchPosts()
        
        self.input = Input()
        self.output = Output(posts: posts)
    }
    
}
