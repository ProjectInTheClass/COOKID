//
//  RankingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class RankingViewModel: ViewModelType, HasDisposeBag {

    struct Input {

    }
    
    struct Output {
        let cookidRankers: Driver<[User]>
        let cookidTopRankers: Driver<[User]>
    }
    
    var input: Input
    var output: Output
    let serviceProvider: ServiceProviderType
    
    init(serviceProvider: ServiceProviderType) {
        self.serviceProvider = serviceProvider
        
        let cookidRankers =
        serviceProvider.userService.fetchCookidRankers()
            .map { $0.sorted(by: { $0.cookidsCount > $1.cookidsCount })}
            .asDriver(onErrorJustReturn: [])
        
        let cookidTopRankers =
        cookidRankers
            .map { users -> [User] in
                var topRankers = [User]()
                for (index, user) in users.enumerated() {
                    if index < 3 {
                        topRankers.append(user)
                    }
                }
                return topRankers
            }
            .asDriver(onErrorJustReturn: [])
        
        self.input = Input()
        self.output = Output(cookidRankers: cookidRankers,
                             cookidTopRankers: cookidTopRankers)
    }
}
