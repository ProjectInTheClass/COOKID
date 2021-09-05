//
//  RealmUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class RealmUserRepo {
    static let instance = RealmUserRepo()
    
    // local의 속도니 completion을 안쓰지만 문제가 생길시 변경
    
    func fetchUser() -> LocalUser? {
        do {
            let realm = try Realm()
            guard let localUser = realm.objects(LocalUser.self).first else { return nil }
            return localUser
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func createUser(user: User, completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            let localUser = LocalUser(nickName: user.nickname, determination: user.determination, goal: user.priceGoal, type: user.userType.rawValue)
            try realm.write {
                realm.add(localUser)
            }
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func updateUser(user: User) {
        do {
            let realm = try Realm()
            if let currentUser = realm.objects(LocalUser.self).first {
                try realm.write {
                    currentUser.nickName = user.nickname
                    currentUser.determination = user.determination
                    currentUser.goal = user.priceGoal
                    currentUser.type = user.userType.rawValue
                }
            } else {
                print("currentUser가 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
}
