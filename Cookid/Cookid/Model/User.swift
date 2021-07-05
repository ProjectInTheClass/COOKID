//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

struct User {
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: UserType
}

enum UserType {
    case preferDineOut
    case preferDineIn
}
