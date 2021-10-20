//
//  Post.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/10.
//

import Foundation
import UIKit

class Post {
    let postID: String
    let user: User
    var images: [URL?]
    var caption: String
    var likes: Int
    var star: Int
    var collections: Int
    var mealBudget: Int
    var location: String
    var timeStamp: Date
    var didLike: Bool
    var didCollect: Bool
    var comments: [Comment]
    
    init(postID: String, user: User, images: [URL?], likes: Int, collections: Int, star: Int, caption: String, mealBudget: Int, location: String, timeStamp: Date, didLike: Bool, didCollect: Bool, comments: [Comment] = []) {
        self.postID = postID
        self.user = user
        self.images = images
        self.star = star
        self.likes = likes
        self.collections = collections
        self.caption = caption
        self.mealBudget = mealBudget
        self.location = location
        self.timeStamp = timeStamp
        self.didLike = didLike
        self.didCollect = didCollect
        self.comments = comments
    }
}

class PostValue {
    var caption: String = ""
    var region: String = ""
    var price: Int = 0
    var star: Int = 0
}
