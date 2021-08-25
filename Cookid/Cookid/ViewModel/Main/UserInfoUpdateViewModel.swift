//
//  UserInfoUpdateViewModel.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/14.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoUpdateViewModel: ViewModelType {
    
    let userService: UserService
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickNameText: BehaviorSubject<String>
        let budgetText: BehaviorSubject<String>
        let determinationText: BehaviorSubject<String>
    }
    
    struct Output {
        
        let userInfo: Driver<User>
        let newUserInfo: Observable<User>
    }
    
    var input: Input
    var output: Output
    
    init(userService: UserService) {
        self.userService = userService
      
        
        let userInfo = userService.user()
            .asDriver(onErrorJustReturn: User(userID: "", nickname: "", determination: "", priceGoal: "", userType: .preferDineIn))
        
        let nickNameText = BehaviorSubject<String>(value:"")
        
        let budgetText = BehaviorSubject<String>(value: "")
        
        let determinationText = BehaviorSubject<String>(value: "")
        
        
        let newUserInfo = Observable.combineLatest(nickNameText.asObservable(), budgetText.asObservable(), determinationText.asObservable(), userInfo.asObservable()) {
            (nickName, buget, determination, currentUser) -> User in
            
            
            let newNickname = nickName.isEmpty ? currentUser.nickname : nickName
            let newBudget = buget.isEmpty ? currentUser.priceGoal : buget
            let newDetermination = determination.isEmpty ? currentUser.determination : determination
            
            
            let newUser = User(userID: currentUser.userID, nickname: newNickname, determination: newDetermination, priceGoal: newBudget, userType: currentUser.userType)
            
            return newUser
        }
        
        
        self.input = Input(nickNameText: nickNameText, budgetText: budgetText, determinationText: determinationText)
        
        self.output = Output(userInfo: userInfo, newUserInfo: newUserInfo)
    }
    
}
