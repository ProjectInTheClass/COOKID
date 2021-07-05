//
//  OnboardingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class OnboardingViewModel: ViewModelType {
    
    struct Input {
        let nickname: BehaviorSubject<String>
        let monthlyGoal: BehaviorSubject<Int>
        let usertype: BehaviorSubject<UserType>
        let determination: BehaviorSubject<String>
    }
    
    struct Output {
        let userInformation: Observable<User>
    }
    
    var input: Input
    
    var output: Output
    
    init() {
        
        let nickname = BehaviorSubject(value: "노네임")
        let monthlyGoal = BehaviorSubject(value: 0)
        let usertype = BehaviorSubject(value: UserType.preferDineIn)
        let determination = BehaviorSubject(value: "화이팅!")
        
        let userInformation = Observable.combineLatest(nickname, determination, usertype, monthlyGoal)
            .map { o1, o2, o3, o4 -> User in
                let newUser = User(nickname: o1, determination: o2, priceGoal: o4, userType: o3)
                return newUser
            }
        
        self.input = Input(nickname: nickname.asObserver(), monthlyGoal: monthlyGoal.asObserver(), usertype: usertype.asObserver(), determination: determination.asObserver())
        
        self.output = Output(userInformation: userInformation)
    }
    
    
}
