//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxDataSources

struct User {
    var userID: String
    var nickname: String
    var determination: String
    var priceGoal: String
    var userType: UserType
}

enum UserType: String {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
}

struct UserSection {
    var header: UIView
    var items: [User]
    
    init(header: UIView, items: [User]) {
        self.header = header
        self.items = items
    }
}

extension UserSection : SectionModelType {
    init(original: UserSection, items: [User]) {
        self = original
        self.items = items
    }
}
