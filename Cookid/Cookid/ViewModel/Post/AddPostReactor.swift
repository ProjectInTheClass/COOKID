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
    
    let postID: String
    let postService: PostService
    let userService: UserService
    
    enum Action {
        case imageUpload([UIImage])
        case makePost(Post)
        case buttonValidation(Bool)
        case uploadPostButtonTapped
    }
    
    enum Mutation {
        case setImages([UIImage])
        case setPost(Post)
        case setValidation(Bool)
        case setLoading(Bool)
        case uploadNewPost(Post)
    }
    
    struct State {
        var newPost: Post?
        var images: [UIImage]
        var validation: Bool
        var isLoading: Bool
    }
    
    let initialState: State
    
    init(postID: String, postService: PostService, userService: UserService) {
        self.postID = postID
        self.userService = userService
        self.postService = postService
        
        self.initialState = State(newPost: nil, images: [], validation: false, isLoading: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .imageUpload(let images):
            return Observable.just(Mutation.setImages(images))
        case .buttonValidation(let valid):
            return Observable.just(Mutation.setValidation(valid))
        case .uploadPostButtonTapped:
            guard let post = self.currentState.newPost else {
                return Observable.empty()
            }
            postService.createPost(post: post)
            return Observable.just(Mutation.uploadNewPost(post))
        case .makePost(let post):
            return Observable.just(Mutation.setPost(post))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .downloadImageURL(let images):
            newState.images = images
        case .setValidation(let validation):
            newState.validation = validation
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .uploadNewPost(_):
            break
        case .setPost(let post):
            newState.newPost = post
        }
        return newState
    }
    
}


