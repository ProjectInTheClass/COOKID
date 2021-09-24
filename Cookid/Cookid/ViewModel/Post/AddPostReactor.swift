//
//  AddPostReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import Foundation
import ReactorKit
import YPImagePicker


class AddPostReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    
    enum Action {
        case selectImageButton
    }
    
    enum Mutation {
        case setImage([UIImage])
    }
    
    struct State {
        var images: [UIImage]
    }
    
    let initialState: State
    
    init(postService: PostService, userService: UserService) {
        self.userService = userService
        self.postService = postService
        
        self.initialState = State(images: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectImageButton:
            
           
            return Observable.just(Mutation.setImage([]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setImage(let images):
            state.images = images
        }
        return state
    }
    
}
