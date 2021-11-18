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
    
    override init(serviceProvider: ServiceProviderType) {
        self.input = Input()
        self.output = Output()
        super.init(serviceProvider: serviceProvider)
        
        let currentUser = serviceProvider.userService.currentUser
        
        currentUser
            .bind(to: output.user)
            .disposed(by: disposeBag)
        
        serviceProvider.postService.totalPosts
            .bind(to: output.posts)
            .disposed(by: disposeBag)
        
        input.fetchPastPosts
            .withLatestFrom(
                Observable.combineLatest(
                    currentUser,
                    output.isLoading,
                    resultSelector: { ($0, $1) }
                ))
            .filter({ (user, isLoading) in
                guard !isLoading else { return false }
                return true
            })
            .withUnretained(self)
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .bind(onNext: { owner, values in
                print("after")
                owner.output.isLoading.accept(true)
                owner.serviceProvider.postService.fetchLastPosts(currentUser: values.0) { success in
                    owner.output.isLoading.accept(!success)
                }
            })
            .disposed(by: disposeBag)
        
        input.fetchFreshPosts
            .withLatestFrom(currentUser)
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.serviceProvider.postService.fetchLatestPosts(currentUser: user)
            })
            .disposed(by: disposeBag)
        
        input.fetchInitialPosts
            .withLatestFrom(currentUser)
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.serviceProvider.postService.fetchLastPosts(currentUser: user, completion: { _ in })
            })
            .disposed(by: disposeBag)
                
    }
    
    func fetchInitialDate() {
        serviceProvider.userService.loadMyInfo()
        input.fetchInitialPosts.accept(())
    }
    
}
