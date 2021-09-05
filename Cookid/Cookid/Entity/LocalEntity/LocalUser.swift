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
    @Persisted var nickName: String
    @Persisted var determination: String
    @Persisted var goal: Int
    @Persisted var type: String

    convenience init(nickName: String, determination: String, goal: Int, type: String) {
        self.init()
        self.nickName = nickName
        self.determination = determination
        self.goal = goal
        self.type = type
    }
}
