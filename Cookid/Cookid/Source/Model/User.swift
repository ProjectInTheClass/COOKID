//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxDataSources

struct User {
    let id: String
    var image: URL?
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: UserType
    var dineInCount: Int
    var cookidsCount: Int
}

enum UserType: String, Codable {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
    
    enum CodingKeys: String, CodingKey {
        case preferDineOut = "외식러"
        case preferDineIn = "집밥러"
    }
}
