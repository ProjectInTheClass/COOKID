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
    
    func createComment(comment: Comment) {
        FirestoreCommentRepo.instance.createComment(comment: comment) { result in
            switch result {
            case .success(.success) :
                print("success")
            case .failure(.failure) :
                print("failure")
            default :
                break
            }
        }
        comments.append(comment)
        commentStore.onNext(comments)
    }
    
    func fetchComments(postID: String) -> Observable<[Comment]> {
        return Observable.create { observer in
//            FirestoreCommentRepo.instance.fetchComments(postID: postID) { entities in
//                var newComments = [Comment]()
//                entities.forEach { entity in
//                    FirestoreUserRepo.instance.fetchUser(userID: entity.userID) { user in
//                        guard let user = user else { return }
//                        let didLike = entity.didLike[entity.userID] == nil
//                        let isReported = entity.isReported[entity.userID] == nil
////                        let newComment = Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: user, content: entity.content, timestamp: entity.timestamp, didLike: didLike, likes: entity.didLike.count, isReported: isReported)
////                        newComments.append(newComment)
//                    }
//                }
//                observer.onNext(newComments)
//                self.comments = newComments
//                self.commentStore.onNext(newComments)
//            }
            return Disposables.create()
        }
    }
    
    func fetchSubComment(postID: String, parentID: String) -> Observable<[Comment]> {
        return Observable.create { observer in
//            FirestoreCommentRepo.instance.fetchSubComments(postID: postID, parentID: parentID) { entities in
//                var newComments = [Comment]()
//                entities.forEach { entity in
//                    FirestoreUserRepo.instance.fetchUser(userID: entity.userID) { user in
//                        guard let user = user else { return }
//                        let didLike = entity.didLike[entity.userID] == nil
//                        let isReported = entity.isReported[entity.userID] == nil
////                        let newComment = Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: user, content: entity.content, timestamp: entity.timestamp, didLike: didLike, likes: entity.didLike.count, isReported: isReported)
////                        newComments.append(newComment)
//                    }
//                }
//                observer.onNext(newComments)
//            }
            return Disposables.create()
        }
    }
    
}
