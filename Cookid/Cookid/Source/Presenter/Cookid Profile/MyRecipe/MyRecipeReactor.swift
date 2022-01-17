//
//  MyRecipeReactor.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/07.
//

import Foundation
import RxSwift
import ReactorKit

class MyRecipeReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutate {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    let serviceProvider: ServiceProviderType
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        self.initialState = State()
    }
}
