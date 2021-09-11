//
//  RemoteComment.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation

struct CommentEntity: Codable {
    var commentID: String
    var postID: String
    var userID: String
    var content: String
    var timestamp: Date
    var isSubComment: Bool
    var didLike: [String:Bool]
    var isReported: [String:Bool]
}
