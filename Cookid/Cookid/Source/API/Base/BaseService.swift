//
//  BaseService.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseService: BaseRepository {
    unowned let serviceProvider: ServiceProviderType
    init(serviceProvider: ServiceProviderType, repoProvider: RepositoryProviderType) {
        self.serviceProvider = serviceProvider
        super.init(repoProvider: repoProvider)
    }
    
    func convertEntityToPost(entity: PostEntity, currentUser: User, postUser: User, commentsCount: Int) -> Post {
        let didLike = entity.didLike.contains(currentUser.id)
        let didCollect = entity.didCollect.contains(currentUser.id)
        let imageURL = entity.images.map { URL(string: $0) }
        return Post(postID: entity.postID, user: postUser, images: imageURL, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: didCollect, commentCount: commentsCount)
    }
    
    func convertEntityToUser(entity: UserEntity) -> User {
        return User(id: entity.id, image: URL(string: entity.imageURL), nickname: entity.nickname, determination: entity.determination, priceGoal: entity.priceGoal, userType: UserType.init(rawValue: entity.userType) ?? .preferDineIn, dineInCount: entity.dineInCount, cookidsCount: entity.cookidsCount)
    }
    
    func convertEntityToComment(commentUser: User, entity: CommentEntity) -> Comment {
        return Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: commentUser, content: entity.content, timestamp: entity.timestamp)
    }
    
    func convertEntityToPhoto(entity: PhotoEntity) -> Photo {
        return Photo(url: entity.url, timeStamp: entity.timeStamp)
    }
}
