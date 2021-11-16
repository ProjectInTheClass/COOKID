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
    
    func convertEntityToComment(currentUser: User, entity: CommentEntity?) -> Comment? {
        guard let entity = entity else { return nil }
        return Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: currentUser, content: entity.content, timestamp: entity.timestamp, didLike: false, likes: 0)
    }
}
