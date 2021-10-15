//
//  RankingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import Foundation
import RxSwift
import RxDataSources

class RankingViewModel: ViewModelType {
    
    let userService: UserService
    
    struct Input { }
    
    struct Output {
        let dineInTopRankers: Observable<[User]>
        let cookidTopRankers: Observable<[User]>
        let dineInRankers: Observable<[User]>
        let cookidRankers: Observable<[User]>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService) {
        self.userService = userService
        let dineInRankers = userService.fetchDineInRankers().map { $0.sorted(by: { $0.dineInCount > $1.dineInCount })}
        let cookidRankers = userService.fetchCookidRankers().map { $0.sorted(by: { $0.cookidsCount > $1.cookidsCount })}
        let dineInTopRankers = dineInRankers.map { userService.filteringTopRankers($0) }
        let cookidTopRankers = cookidRankers.map { userService.filteringTopRankers($0) }
        
        self.input = Input()
        self.output = Output(dineInTopRankers: dineInTopRankers, cookidTopRankers: cookidTopRankers, dineInRankers: dineInRankers, cookidRankers: cookidRankers)
    }
    
}
