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
    
    func fetchUser() -> LocalUser? {
        do {
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            let realm = try Realm()
            guard let localUser = realm.objects(LocalUser.self).first else { return nil }
            return localUser
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func createUser(user: User) {
        do {
            let realm = try Realm()
            let localUser = LocalUser()
            localUser.image = "person.circle.fill"
            localUser.goal = user.priceGoal
            localUser.nickName = user.nickname
            localUser.type = user.userType.rawValue
            localUser.determination = user.determination
            try realm.write {
                realm.add(localUser)
            }
        } catch let error {
            print(error)
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
                    // 임시
                    currentUser.image = user.image.description
                }
            } else {
                print("currentUser가 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        do {
            let realm = try Realm()
            if let currentUser = realm.objects(LocalUser.self).filter(NSPredicate(format: "id=%@", user.userID)).first {
                try realm.write {
                    realm.delete(currentUser)
                }
            } else {
                print("currentUser가 없습니다!")
            }
        } catch let error {
            print(error)
        }
    }
}
