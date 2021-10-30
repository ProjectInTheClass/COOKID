//
//  PostEditReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit




final class PostEditReactor: Reactor {
    
    let postService: PostService
    let userService: UserService
    
    enum Action {
        case updateImages([UIImage])
        case updateCaption(String)
        case updateRegion(String)
        case updatePrice(Int)
        case updateStar(Int)
    }
    
    enum Mutation {
        case setImages([UIImage])
        case setCaption(String)
        case setRegion(String)
        case setPrice(Int)
        case setStar(Int)
        case setUser(User)
        case setValidation(Bool)
    }
    
    struct State {
        var images: [UIImage]
        var caption: String
        var region: String
        var price: Int
        var star: Int
        var user: User = DummyData.shared.singleUser
        var isValid: Bool = false
    }
    
    let initialState: State
    
    init(postService: PostService, userService: UserService, mode: PostEditViewMode) {
        
    }
    
}
