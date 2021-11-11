//
//  RemotePost.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation

struct PostEntity {
    let postID: String
    let userID: String
    var images: [URL?]
    var star: Int
    var caption: String
    var mealBudget: Int
    var timestamp: Date
    var location: String
    var didLike: [String:Bool]
    var didCollect: [String:Bool]
    var isReported: [String:Bool]
}

extension PostEntity: FirebaseConvertable {
    func toDocument() -> [String : Any] {
        return [
            "postID" : self.postID,
            "userID" : self.userID,
            "images" : self.images,
            "star" : self.star,
            "caption" : self.caption,
            "mealBudget" : self.mealBudget,
            "timeStamp" : self.timestamp
        ]
    }
}
