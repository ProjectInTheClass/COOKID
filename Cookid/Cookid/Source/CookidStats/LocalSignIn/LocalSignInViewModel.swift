//
//  LocalSignInViewModel.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import RxSwift
import RxCocoa
import NSObject_Rx
import FirebaseAnalytics

class LocalSignInViewModel: BaseViewModel, ViewModelType, HasDisposeBag {

    struct Input {
        let nickname = PublishRelay<String>()
        let monthlyGoal = PublishRelay<String>()
        let usertype = BehaviorRelay<UserType>(value: .preferDineIn)
        let determination = PublishRelay<String>()
        let completeButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isError = PublishRelay<Bool?>()
        let nicknameValidation = PublishRelay<Bool?>()
        let monthlyGoalValidation = PublishRelay<Bool?>()
        let determinationValidation = PublishRelay<Bool?>()
    }

    var input: Input = Input()
    var output: Output = Output()
    
    override init(serviceProvider: ServiceProviderType) {
        super.init(serviceProvider: serviceProvider)
        
        input.determination
            .map(validationText)
            .bind(to: output.determinationValidation)
            .disposed(by: disposeBag)
        
        input.nickname
            .map(validationText)
            .bind(to: output.nicknameValidation)
            .disposed(by: disposeBag)
        
        input.monthlyGoal
            .map(validationNum)
            .bind(to: output.monthlyGoalValidation)
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .withLatestFrom(
                Observable.combineLatest(
                    input.nickname,
                    input.determination,
                    input.usertype,
                    input.monthlyGoal
                        .map { Int($0) ?? 0 },
                    resultSelector: { name, determine, usertype, monthlyGoal -> User in
                        return User(id: UUID().uuidString,
                                    nickname: name,
                                    determination: determine,
                                    priceGoal: monthlyGoal,
                                    userType: usertype,
                                    dineInCount: 0,
                                    cookidsCount: 0)
                    }))
            .bind(onNext: { [weak self] user in
                guard let self = self else { return }
                serviceProvider.userService.creatUser(user: user) { self.output.isError.accept(!$0) }
                Analytics.setUserProperty(user.userType.rawValue, forName: "user_type")
            })
            .disposed(by: disposeBag)
    }
    
    func validationText(_ text: String) -> Bool {
        return text.count > 1
    }
    
    private let charSet: CharacterSet = {
        var cs = CharacterSet(charactersIn: "0123456789")
        return cs.inverted
    }()
    
    func validationNum(_ text: String) -> Bool {
        if text.isEmpty && text == "" {
            return false
        } else {
            guard text.rangeOfCharacter(from: charSet) == nil else { return false }
            return true
        }
    }
}
