//
//  LocalShopping.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/02.
//

import Foundation
import RealmSwift

class LocalShopping: Object {
    
    @Persisted var id: String
    @Persisted var date: Date
    @Persisted var price: Int
    
    convenience init(id: String, date: Date, price: Int) {
        self.init()
        self.id = id
        self.date = date
        self.price = price
    }
}
