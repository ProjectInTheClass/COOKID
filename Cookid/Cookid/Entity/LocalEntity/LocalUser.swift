//
//  LocalUser.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class LocalUser : Object {
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var name: String = ""
    @Persisted var age: Int?
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
