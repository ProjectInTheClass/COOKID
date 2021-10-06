//
//  RemoteUser.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/29.
//

import Foundation

class UserEntity: Codable {
    let id: String
    var imageURL: URL?
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: String
    var dineInCount: Int?
    var cookidsCount: Int?
    
    init(id: String, imageURL: URL?, nickname: String, determination: String, priceGoal: Int, userType: UserType, dineInCount: Int?, cookidsCount: Int?) {
        self.id = id
        self.imageURL = imageURL
        self.nickname = nickname
        self.determination = determination
        self.priceGoal = priceGoal
        self.userType = userType.rawValue
        self.dineInCount = dineInCount
        self.cookidsCount = cookidsCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL
        case nickname
        case determination
        case priceGoal
        case userType
        case dineInCount
        case cookidsCount
    }
}
