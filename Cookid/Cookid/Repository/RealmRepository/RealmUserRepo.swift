//
//  RealmUserRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class RealmUserRepo {
    static let shared = RealmUserRepo()
    
    func createPerson() {
        do {
            let realm = try Realm()
            let person1 = LocalUser()
            person1.name = "철수"
            person1.age = 10
            let person2 = LocalUser()
            person2.name = "영희"
            person2.age = 11
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            try realm.write {
                realm.add(person1)
                realm.add(person2)
            }
        } catch let error {
            print(error)
        }
       
    }
}
