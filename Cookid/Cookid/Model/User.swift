//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

struct User {
    var userID: String?
    var nickname: String
    var determination: String
    var priceGoal: String
    var userType: UserType
}

enum UserType: String {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
}
