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
    var convertToDic: [String:Any] {
        let dic: [String:Any] = [
            "nickname" : nickname,
            "determination" : determination,
            "priceGoal" : priceGoal,
            "userType" : userType.rawValue
        ]
        return dic
    }
    
}

enum UserType: String {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
}
