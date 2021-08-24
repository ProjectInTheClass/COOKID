//
//  Shopping.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/23.
//

import UIKit
import RxDataSources
import RxSwift

class GroceryShopping {
    let id: String
    var date: Date
    var totalPrice: Int
    let image = UIImage(named: "shopping-cart")!
    
    init(id: String, date: Date, totalPrice: Int) {
        self.id = id
        self.date = date
        self.totalPrice = totalPrice
    }
}

struct ShoppingSection {
   typealias Item = GroceryShopping
    var header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension ShoppingSection: SectionModelType {
    init(original: ShoppingSection, items: [Item]) {
        self = original
        self.items = items
    }
}
