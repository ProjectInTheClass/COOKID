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
    
    struct Input {
        let fetchInitialPosts = PublishRelay<Void>()
        let fetchPastPosts = PublishRelay<Void>()
        let fetchFreshPosts = PublishRelay<Void>()
    }
    
    struct Output {
        let posts = PublishRelay<[Post]>()
        let user = BehaviorRelay<User>(value: DummyData.shared.secondUser)
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    var input: Input
    var output: Output
    
    let userService: UserServiceType
    let postService: PostServiceType
    let shoppingService: ShoppingServiceType
    let mealService: MealServiceType
    
    init(userService: UserServiceType,
         postService: PostServiceType,
         shoppingService: ShoppingServiceType,
         mealService: MealServiceType) {
        self.shoppingService = shoppingService
        self.mealService = mealService
        self.userService = userService
        self.postService = postService
        self.input = Input()
        self.output = Output()
        
        let currentUser = userService.currentUser
        
        currentUser
            .bind(to: output.user)
            .disposed(by: disposeBag)
        
        postService.totalPosts
            .debug()
            .bind(to: output.posts)
            .disposed(by: disposeBag)
        
        input.fetchPastPosts
            .withLatestFrom(
                Observable.combineLatest(
                    currentUser,
                    output.isLoading,
                    resultSelector: { ($0, $1) }
                ))
            .filter({ (_, isLoading) in
                guard !isLoading else { return false }
                return true
            })
            .distinctUntilChanged({ $0.1 != $1.1 })
            .withUnretained(self)
            .bind(onNext: { owner, values in
                owner.output.isLoading.accept(true)
                owner.postService.fetchLastPosts(currentUser: values.0) { success in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        owner.output.isLoading.accept(!success)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.fetchFreshPosts
            .withLatestFrom(currentUser)
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.postService.fetchLatestPosts(currentUser: user)
            })
            .disposed(by: disposeBag)
        
        input.fetchInitialPosts
            .withLatestFrom(currentUser)
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.postService.fetchLastPosts(currentUser: user, completion: { _ in })
            })
            .disposed(by: disposeBag)
                
    }
    
    func fetchInitialDate() {
        self.userService.loadMyInfo()
        input.fetchInitialPosts.accept(())
    }
    
}
