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
    var mealBudget: Int
    var location: String
    var star: Int
    var collections: Int
    var likes: Int
    var timeStamp: Date
    var didLike: Bool
    var didCollect: Bool
    var commentCount: Int
    
    init(postID: String, user: User, images: [URL?], likes: Int = 0, collections: Int = 0, star: Int, caption: String, mealBudget: Int, location: String, timeStamp: Date = Date(), didLike: Bool = false, didCollect: Bool = false, commentCount: Int = 0) {
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
        self.commentCount = commentCount
    }
}
