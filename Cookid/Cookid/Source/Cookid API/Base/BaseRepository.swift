//
//  BaseRepository.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseRepository {
    
    func convertCommentToEntity(_ comment: Comment) -> CommentEntity {
        return CommentEntity(commentID: comment.commentID, postID: comment.postID, parentID: comment.parentID, userID: comment.user.id, content: comment.content, timestamp: comment.timestamp, didLike: [], isReported: [])
    }
    
    func convertUserToEntity(_ user: User) -> UserEntity {
        return UserEntity(id: user.id, imageURL: user.image!.absoluteString, nickname: user.nickname, determination: user.determination, priceGoal: user.priceGoal, userType: user.userType.rawValue, dineInCount: user.dineInCount, cookidsCount: user.cookidsCount)
    }
    
    func convertPostToEntity(_ post: Post) -> PostEntity {
        let images = post.images.map { url -> String in
            guard let urlString = url?.absoluteString else { return "" }
            return urlString
        }
        return PostEntity(postID: post.postID, userID: post.user.id, images: images, star: post.star, caption: post.caption, mealBudget: post.mealBudget, timestamp: post.timeStamp, location: post.location, didLike: [], didCollect: [], isReported: [])
    }
    
}
