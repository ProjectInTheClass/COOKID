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
    private(set) var timestamp: Date
    private(set) var didLike: Bool = false
    private(set) var likes: Int = 0
    
    mutating func setCurrentDate() {
        self.timestamp = Date()
    }
    
    mutating func like() {
        if self.didLike {
            self.likes -= 1
        } else {
            self.likes += 1
        }
        self.didLike.toggle()
    }
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
