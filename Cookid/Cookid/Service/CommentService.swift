//
//  CommentService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import RxSwift

class CommentService {
    
    private var comments = [Comment]()
    private lazy var commentStore = BehaviorSubject<[Comment]>(value: comments)
    
    func createComment() {
        
    }
    
    func fetchComments(postID: String) -> Observable<[Comment]> {
        return Observable.create { observer in
            
            FirestoreCommentRepo.instance.fetchComments(postID: postID) { entities in
                observer.onNext(entities.map({ entity in
                    let didLike = entity.didLike[entity.userID] == nil
                    let isReported = entity.isReported[entity.userID] == nil
                    return Comment(commentID: entity.commentID, postID: entity.postID, userID: entity.userID, content: entity.content, timestamp: entity.timestamp, isSubComment: entity.isSubComment, didLike: didLike, isReported: isReported)
                }))
            }
            
            return Disposables.create()
        }
    }
    
}
