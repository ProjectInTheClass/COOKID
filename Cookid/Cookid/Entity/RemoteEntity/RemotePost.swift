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
    var images: [URL]
    var caption: String
    var likes: Int
    var timestamp: Date
    var didLike: [String:Bool]
    var didCollect: [String:Bool]
    var isReported: [String:Bool]
}



