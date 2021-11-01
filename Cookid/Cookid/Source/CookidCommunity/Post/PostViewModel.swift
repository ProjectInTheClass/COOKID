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

class PostViewModel: BaseViewModel, ViewModelType, HasDisposeBag {
    
    struct Input {

    }
    
    struct Output {
        let posts: Observable<[Post]>
        let user: Observable<User>
    }
    
    var input: Input
    var output: Output
    
    override init(serviceProvider: ServiceProviderType) {
        let user = serviceProvider.userService.currentUser
        let posts =
        Observable.merge(
            serviceProvider.postService.totalPosts,
            user.flatMap(serviceProvider.postService.fetchLastPosts))
        self.input = Input()
        self.output = Output(posts: posts, user: user)
        super.init(serviceProvider: serviceProvider)
    }
    
}
