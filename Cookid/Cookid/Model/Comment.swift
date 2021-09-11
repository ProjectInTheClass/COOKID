//
//  Comment.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation

struct Comment: Codable {
    var commentID: String
    var postID: String
    var userID: String
    var content: String
    var timestamp: Date
    var isSubComment: Bool
    var didLike: Bool
    var isReported: Bool
}
