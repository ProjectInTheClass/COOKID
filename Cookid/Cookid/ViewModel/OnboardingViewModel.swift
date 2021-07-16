//
//  OnboardingViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import RxSwift
import RxCocoa

class OnboardingViewModel: ViewModelType {
    
    let userService: UserService
    
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
    
    init(userService: UserService) {
        self.userService = userService
        
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
    
    func registrationUser() {
        self.output.userInformation
            .drive(onNext: { [unowned self] user in
                self.userService.uploadUserInfo(user: user)
            })
            .disposed(by: disposeBag)
    }
    
    func validationText(text: String) -> Bool {
        return text.count > 1
    }
    
    let charSet: CharacterSet = {
        var cs = CharacterSet.init(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNum(text: String) -> Bool {
        if text.isEmpty {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }
}
