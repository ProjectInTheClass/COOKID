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
    var images: [UIImage]
    var caption: String
    var likes = 0
    var star: Int
    var collections = 0
    var mealBudget: Int
    var location: String
    var timestamp = Date()
    var didLike = false
    var didCollect = false
    var isReported = false
    
    init(postID: String, user: User, images: [UIImage], star: Int, caption: String, mealBudget: Int, location: String) {
        self.postID = postID
        self.user = user
        self.images = images
        self.star = star
        self.caption = caption
        self.mealBudget = mealBudget
        self.location = location
    }
}
