//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxDataSources

struct User {
    var image: UIImage = UIImage(systemName: "person.circle.fill")!
    var userID: String
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: UserType
}

enum UserType: String {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
}

struct UserSection {
    var header: UIView
//    var items: [User]
    var items: [UserForRanking]
    
    init(header: UIView, items: [UserForRanking]) {
        self.header = header
        self.items = items
    }
}

extension UserSection : SectionModelType {
    init(original: UserSection, items: [UserForRanking]) {
        self = original
        self.items = items
    }
}

struct UserForRanking {
    var nickname: String
    var userType: UserType
    var determination: String
    var groceryMealSum: Int
}
