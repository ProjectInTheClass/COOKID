//
//  MyPostReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyPostReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let myPost: Post
    }
    
    let initialState: State
    
    init(myPost: Post) {
        self.initialState = State(myPost: myPost)
    }
    
    
}
