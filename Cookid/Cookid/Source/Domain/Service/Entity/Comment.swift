//
//  Comment.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation

struct Comment {
    let commentID: String
    let postID: String
    let parentID: String?
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

extension Comment: Equatable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.commentID == rhs.commentID
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
