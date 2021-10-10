//
//  CommentCellReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/10.
//

import Foundation
import RxSwift
import ReactorKit
import RxDataSources

final class CommentCellReactor: Reactor {
    
    enum Action {
        case delete
        case update
    }
    
    enum Mutation {
        case deleteComment(Comment)
        case updateComment(Comment)
    }
    
    struct State {
        let comment: Comment
    }
    
    let initialState: State
    
    init(comment: Comment) {
        self.initialState = State(comment: comment)
    }
   
}
