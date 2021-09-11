//
//  Post.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation

class Post {
    let postID = UUID().uuidString
    let user: User
    var images: [URL?]
    var caption: String
    var likes = 0
    var timestamp = Date()
    var didLike = false
    var didCollect = false
    var isReported = false
    
    init(user: User, images: [URL], caption: String) {
        self.user = user
        self.images = images
        self.caption = caption
    }
}
