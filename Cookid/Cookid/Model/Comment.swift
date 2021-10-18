//
//  Comment.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation
import RxDataSources

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
}

struct CommentSection: SectionModelType  {
    var header: Comment
    var items: [Comment]
    
    init(original: Self, items: [Comment]) {
        self = original
        self.items = items
    }
    
    init(header: Comment, items: [Comment]) {
        self.header = header
        self.items = items
    }
}
