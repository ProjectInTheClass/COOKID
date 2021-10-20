//
//  PostViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class PostViewModel: ViewModelType, HasDisposeBag {
    
    let mealService: MealService
    let shoppingService: ShoppingService
    let postService: PostService
    let commentService: CommentService
    let userService: UserService
    
    struct Input {
//        let naverLogin: BehaviorRelay<Bool>
    }
    
    struct Output {
        let posts: Observable<[Post]>
        let user: Observable<User>
    }
    
    var input: Input
    var output: Output
    
    init(postService: PostService, userService: UserService, commentService: CommentService, mealService: MealService, shoppingService: ShoppingService) {
        self.mealService = mealService
        self.shoppingService = shoppingService
        self.postService = postService
        self.userService = userService
        self.commentService = commentService
        
        let user = userService.user()
        
        
        
        let fetchPost = Observable.of(postService.totalPosts, user.flatMap(postService.fetchLastPosts(currentUser:))).merge()
 
//        let naverLogin = BehaviorRelay<Bool>(value: false)
        
        self.input = Input()
        self.output = Output(posts: fetchPost, user: user)
    }
    
}
