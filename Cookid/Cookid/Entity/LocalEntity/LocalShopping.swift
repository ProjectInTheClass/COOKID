//
//  LocalShopping.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class LocalShopping: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var price: Int
    
    convenience init(date: Date, price: Int) {
        self.init()
        self.date = date
        self.price = price
    }
}
