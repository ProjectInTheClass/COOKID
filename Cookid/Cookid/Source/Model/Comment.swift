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
    var likes: Int
}

struct CommentSection {
    var header: Comment
    var items: [Comment]
    var isOpened: Bool

    init(header: Comment, items: [Comment], isOpened: Bool = false) {
        self.header = header
        self.items = items
        self.isOpened = isOpened
    }
}
