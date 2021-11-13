//
//  PostCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class PostCellReactor: Reactor {
    
    enum Action {
        case heartbuttonTapped(Bool)
        case bookmarkButtonTapped(Bool)
        case deleteButtonTapped(Post)
        case reportButtonTapped(Post)
    }
    
    enum Mutation {
        case setHeart(Bool)
        case setHeartCount(Int)
        case setBookmark(Bool)
        case setBookmarkCount(Int)
        case setUser(User)
        case setCurrentPercent(Double)
        case deletePost(Bool)
    }
    
    struct State {
        var post: Post
        var currentPercent: Double
        var isHeart: Bool
        var isBookmark: Bool
        var heartCount: Int
        var bookmarkCount: Int
        var user: User = DummyData.shared.singleUser
        var isError: Bool = false
    }
    
    let initialState: State
    let serviceProvider: ServiceProviderType
    let sender: UIViewController
    
    init(sender: UIViewController, post: Post,
         serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        self.sender = sender
        self.initialState = State(post: post, currentPercent: 0, isHeart: post.didLike, isBookmark: post.didCollect, heartCount: post.likes, bookmarkCount: post.collections)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let currentPercent =
        Observable.combineLatest(
            serviceProvider.mealService.spotMonthMeals,
            serviceProvider.userService.currentUser,
            serviceProvider.shoppingService.spotMonthShoppings,
            Observable.just(self.currentState.post),
            resultSelector: calculateCurrentPercent)
            .map { Mutation.setCurrentPercent($0) }
        let user = serviceProvider.userService.currentUser
            .map { Mutation.setUser($0) }
        return Observable.merge(mutation, user, currentPercent)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        let post = self.currentState.post
        let user = self.currentState.user
        
        switch action {
        case .heartbuttonTapped(let isHeart):
            self.postUpdateByHeart(post: post, isHeart: isHeart)
            serviceProvider.postService.heartTransaction(sender: self.sender, currentUser: user, post: post, isHeart: isHeart)
            return Observable.concat([
                Observable.just(Mutation.setHeart(isHeart)),
                Observable.just(Mutation.setHeartCount(self.currentState.post.likes))])
        case .bookmarkButtonTapped(let isBookmark):
            self.postUpdateByBookmark(post: post, isBookmark: isBookmark)
            serviceProvider.postService.bookmarkTransaction(sender: self.sender, currentUser: user, post: post, isBookmark: isBookmark)
            return Observable.concat([
                Observable.just(Mutation.setBookmark(isBookmark)),
                Observable.just(Mutation.setBookmarkCount(self.currentState.post.collections))])
        case .deleteButtonTapped(let post):
            return serviceProvider.postService.deletePost(post: post).map { Mutation.deletePost(!$0) }
        case .reportButtonTapped(let post):
            serviceProvider.postService.reportTransaction(currentUser: user, post: post, isReport: true)
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setUser(let user):
            newState.user = user
            return newState
        case .setHeart(let isHeart):
            newState.isHeart = isHeart
            return newState
        case .setBookmark(let isBookmark):
            newState.isBookmark = isBookmark
            return newState
        case .setHeartCount(let heartCount):
            newState.heartCount = heartCount
            return newState
        case .setBookmarkCount(let bookmarkCount):
            newState.bookmarkCount = bookmarkCount
            return newState
        case .deletePost(let isError):
            newState.isError = isError
            return newState
        case .setCurrentPercent(let percent):
            newState.currentPercent = percent
            return newState
        }
    }
    
    func postUpdateByHeart(post: Post, isHeart: Bool) {
        if isHeart {
            post.likes += 1
            post.didLike = isHeart
        } else {
            post.likes -= 1
            post.didLike = isHeart
        }
    }
    
    func postUpdateByBookmark(post: Post, isBookmark: Bool) {
        if isBookmark {
            post.collections += 1
            post.didCollect = isBookmark
        } else {
            post.collections -= 1
            post.didCollect = isBookmark
        }
    }
    
    func calculateCurrentPercent(_ meals: [Meal], _ user: User, _ shoppings: [Shopping], _ post: Post) -> Double {
        let postMealBudget = Double(post.mealBudget)
        let shoppingSpends = shoppings.map { Double($0.totalPrice) }.reduce(0, +)
        let mealSpend = meals.map { Double($0.price) }.reduce(0, +)
        let totalSpend = (shoppingSpends + mealSpend + postMealBudget) / Double(user.priceGoal) * 100
        if totalSpend.isNaN {
            return 0
        } else {
            return totalSpend
        }
    }
    
}
