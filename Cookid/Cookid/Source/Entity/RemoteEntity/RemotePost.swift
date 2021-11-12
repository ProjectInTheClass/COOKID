//
//  RemotePost.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation

struct PostEntity: Codable {
    
    let postID: String
    let userID: String
    var images: [String]
    var star: Int
    var caption: String
    var mealBudget: Int
    var timestamp: Date
    var location: String
    var didLike: [String:Bool]
    var didCollect: [String:Bool]
    var isReported: [String:Bool]
    
    enum CodingKeys: String, CodingKey {
        case postID
        case userID
        case images
        case star
        case caption
        case mealBudget
        case timestamp
        case location
        case didLike
        case didCollect
        case isReported
    }
    
}
