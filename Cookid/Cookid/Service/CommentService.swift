//
//  CommentService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import RxSwift

class CommentService {
    
    let firestoreCommentRepo: FirestoreCommentRepo
    let firestoreUserRepo: FirestoreUserRepo
    
    init(firestoreCommentRepo: FirestoreCommentRepo, firestoreUserRepo: FirestoreUserRepo) {
        self.firestoreCommentRepo = firestoreCommentRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    func createComment(comment: Comment) -> Observable<Bool> {
        return Observable.create { observer in
            self.firestoreCommentRepo.createComment(comment: comment) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success) :
                    print(success)
                    observer.onNext(true)
                case .failure(let error) :
                    print(error)
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteComment(comment: Comment) {
        self.firestoreCommentRepo.deleteComment(comment: comment) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func reportComment(comment: Comment) {
        self.firestoreCommentRepo.deleteComment(comment: comment) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func fetchComments(postID: String, completion: @escaping ([Comment]) -> Void) {
        self.firestoreCommentRepo.fetchComments(postID: postID) { result in
            switch result {
            case .success(let entities):
                var newComments = [Comment]()
                entities.forEach { entity in
                    guard entity.isReported[entity.userID] == nil else { return }
                    self.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                        switch result {
                        case .success(let userEntity):
                            guard let userEntity = userEntity else { return }
                            let user = User(id: userEntity.id, image: userEntity.imageURL, nickname: userEntity.nickname, determination: userEntity.determination, priceGoal: userEntity.priceGoal, userType: UserType(rawValue: userEntity.userType) ?? .preferDineIn, dineInCount: userEntity.dineInCount, cookidsCount: userEntity.cookidsCount)
                            let didLike = entity.didLike[entity.userID] == nil
                            let newComment = Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: user, content: entity.content, timestamp: entity.timestamp, didLike: didLike, likes: entity.didLike.count)
                            newComments.append(newComment)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                completion(newComments)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
