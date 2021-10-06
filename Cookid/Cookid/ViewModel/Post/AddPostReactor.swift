//
//  AddPostReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import YPImagePicker

class AddPostReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    
    enum Action {
        case imageUpload([UIImage])
        case inputRegion(String)
        case inputCaption(String)
        case inputPrice(Int)
        case inputStar(Int)
        case userSetting
        case uploadPostButtonTapped
    }
    
    enum Mutation {
        case setPostValues(PostValue)
        case setImages([UIImage])
        case setUser(User)
        case setLoading(Bool)
        case sendErrorMessage(Bool)
    }
    
    struct State {
        var images: [UIImage] = []
        var postValue = PostValue()
        var user: User = DummyData.shared.singleUser
        var isLoading: Bool = false
        var isError: Bool = false
    }
    
    let initialState: State
    
    init(postService: PostService, userService: UserService) {
        self.userService = userService
        self.postService = postService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .imageUpload(let images):
            return Observable.just(Mutation.setImages(images))
        case .inputRegion(let region):
            let currentPostValue = self.currentState.postValue
            currentPostValue.region = region
            return Observable.just(Mutation.setPostValues(currentPostValue))
        case .inputCaption(let caption):
            let currentPostValue = self.currentState.postValue
            currentPostValue.caption = caption
            return Observable.just(Mutation.setPostValues(currentPostValue))
        case .inputPrice(let price):
            let currentPostValue = self.currentState.postValue
            currentPostValue.price = price
            return Observable.just(Mutation.setPostValues(currentPostValue))
        case .inputStar(let star):
            let currentPostValue = self.currentState.postValue
            currentPostValue.star = star
            return Observable.just(Mutation.setPostValues(currentPostValue))
        case .userSetting:
            return userService.user().map { Mutation.setUser($0) }
        case .uploadPostButtonTapped:
            let postValue = self.currentState.postValue
            let user = self.currentState.user
            let images = self.currentState.images
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.makePost(user: user, postValue: postValue, images: images),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setPostValues(let postValue):
            newState.postValue = postValue
        case .setUser(let user):
            newState.user = user
        case .sendErrorMessage(let isError):
            newState.isError = isError
        }
        return newState
    }
    
    func makePost(user: User, postValue: PostValue, images: [UIImage]) -> Observable<Mutation> {
        return self.postService.createPost(user: user, images: images, postValue: postValue)
            .map { Mutation.sendErrorMessage(!$0) }
    }
    
}
