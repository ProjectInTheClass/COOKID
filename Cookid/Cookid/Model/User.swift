//
//  User.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxDataSources

struct User : Codable {
    let id: String
    var image: URL?
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: UserType
    var dineInCount: Int
    var cookidsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case nickname
        case determination
        case priceGoal
        case userType
        case dineInCount
        case cookidsCount
    }
}

enum UserType: String, Codable {
    case preferDineOut = "외식러"
    case preferDineIn = "집밥러"
    
    enum CodingKeys: String, CodingKey {
        case preferDineOut = "외식러"
        case preferDineIn = "집밥러"
    }
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
