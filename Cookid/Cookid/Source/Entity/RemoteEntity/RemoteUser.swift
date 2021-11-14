//
//  RemoteUser.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/29.
//

import Foundation

struct UserEntity: Codable {
    let id: String
    var imageURL: String
    var nickname: String
    var determination: String
    var priceGoal: Int
    var userType: String
    var dineInCount: Int
    var cookidsCount: Int
    
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
