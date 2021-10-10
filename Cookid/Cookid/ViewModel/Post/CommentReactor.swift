//
//  CommentReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/21.
//

import Foundation
import RxSwift
import ReactorKit
import RxDataSources

// 다시 짜기
final class CommentReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        case setCommentsReactor([CommentCellReactor])
    }
    
    struct State {
        var commentReactors: [CommentCellReactor] = []
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    // comments로 commentsCellReactor 만들기 tranform 
   
}
