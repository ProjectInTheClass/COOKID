//
//  OnboardingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import RxSwift
import RxCocoa

class OnboardingViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: BehaviorSubject<String>
        let monthlyGoal: BehaviorSubject<String>
        let usertype: BehaviorSubject<UserType>
        let determination: BehaviorSubject<String>
    }
    
    struct Output {
        let userInformation: Driver<User>
    }
    
    var input: Input
    
    var output: Output
    
    init() {
        
        let nickname = BehaviorSubject(value: "노네임")
        let monthlyGoal = BehaviorSubject(value: "00")
        let usertype = BehaviorSubject(value: UserType.preferDineIn)
        let determination = BehaviorSubject(value: "화이팅!")
        
        let userInformation = Observable.combineLatest(nickname, determination, usertype, monthlyGoal, resultSelector: { name, deter, usertype, monthlyGoal -> User in
            return User(userID: "", nickname: name, determination: deter, priceGoal: monthlyGoal, userType: usertype)
        })
        .asDriver(onErrorJustReturn: User(userID: "", nickname: "노네임", determination: "아자아자! 화이팅!", priceGoal: "200000", userType: .preferDineIn))
        
        
        self.input = Input(nickname: nickname, monthlyGoal: monthlyGoal, usertype: usertype, determination: determination)
        
        self.output = Output(userInformation: userInformation)
    }
    
    func vaildInformation(_ text: String) -> Bool {
        return text.count < 3
    }
    
    func registrationUser() {
        self.output.userInformation
            .drive(onNext: { user in
                print("등록완료")
                UserRepository.shared.uploadUserInfo(userInfo: user)
            })
            .disposed(by: disposeBag)
    }
    
    
}
