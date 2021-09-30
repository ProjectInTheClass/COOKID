//
//  Comment.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation

struct Comment {
    var commentID: String
    var postID: String
    var parentID: String?
    var user: User
    var content: String
    var timestamp: Date
    var didLike: Bool
    var subComments: [Comment]?
    var likes: Int
    var isReported: Bool
}
