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
        case uploadPostButtonTapped
    }
    
    enum Mutation {
        case setImages([UIImage])
        case setPost(Post)
        case setLoading(Bool)
        case uploadCompletion(Post)
    }
    
    struct State {
        var newPost: Post?
        var images: [UIImage] = []
        var isLoading: Bool = false
        var uploadCompletion: Post?
    }
    
    let initialState: State
    
    init(postID: String, postService: PostService, userService: UserService) {
        self.postID = postID
        self.userService = userService
        self.postService = postService
        
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        
        case .imageUpload(let images):
            return Observable.just(Mutation.setImages(images))
  
        case .makePost(let post):
            return Observable.just(Mutation.setPost(post))
            
        case .uploadPostButtonTapped:
            guard let post = self.currentState.newPost else {
                return Observable.empty()
            }
            postService.createPost(post: post)
            return Observable.just(Mutation.uploadCompletion(post))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImages(let images):
            newState.images = images
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .uploadCompletion(let value):
            newState.uploadCompletion = value
        case .setPost(let post):
            newState.newPost = post
        }
        return newState
    }
}
