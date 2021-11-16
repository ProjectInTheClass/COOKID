//
//  BaseRepository.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import Foundation

class BaseRepository {
    unowned let repoProvider: RepositoryProviderType
    init(repoProvider: RepositoryProviderType) {
        self.repoProvider = repoProvider
    }
    
    func convertCommentToEntity(_ comment: Comment) -> CommentEntity {
        return CommentEntity(commentID: comment.commentID, postID: comment.postID, parentID: comment.parentID, userID: comment.user.id, content: comment.content, timestamp: comment.timestamp, didLike: [], isReported: [])
    }
    
    
    
}
