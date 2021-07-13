//
//  UserService.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/08.
//

import Foundation
import RxSwift

class UserService {
    static let shared = UserService()
    
    private let userRepository = UserRepository()
    
    func loadUserInfo() -> Observable<User> {
        return Observable.create { [unowned self] observer -> Disposable in
            self.userRepository.fetchUserInfo { userentity in
                let user = User(userID: userentity.userId, nickname: userentity.nickname, determination: userentity.determination, priceGoal: userentity.priceGoal, userType: UserType(rawValue: userentity.userType)!)
                observer.onNext(user)
            }
            return Disposables.create()
        }
    }
    
    //삭제 업데이트 생성
}
