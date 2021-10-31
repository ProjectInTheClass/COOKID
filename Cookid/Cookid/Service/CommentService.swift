//
//  CommentService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import RxSwift

class CommentService: BaseService {
    
    let firestoreCommentRepo: FirestoreCommentRepo
    let firestoreUserRepo: FirestoreUserRepo
    
    init(firestoreCommentRepo: FirestoreCommentRepo, firestoreUserRepo: FirestoreUserRepo) {
        self.firestoreCommentRepo = firestoreCommentRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    private var comments = [Comment]()
    private lazy var commentStore = BehaviorSubject(value: comments)
    
    var currentPostComments: Observable<[Comment]> {
        return commentStore
    }
    
    func createComment(comment: Comment) {
        self.comments.append(comment)
        self.commentStore.onNext(self.comments)
        self.firestoreCommentRepo.createComment(comment: comment) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func deleteComment(comment: Comment) {
        
        if let index = comments.firstIndex(where: { $0.commentID == comment.commentID }) {
            self.comments.remove(at: index)
            self.commentStore.onNext(self.comments)
        }
        
        self.firestoreCommentRepo.deleteComment(comment: comment) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func reportComment(comment: Comment, user: User) {
        
        if let index = comments.firstIndex(where: { $0.commentID == comment.commentID }) {
            self.comments.remove(at: index)
            self.commentStore.onNext(self.comments)
        }
        
        self.firestoreCommentRepo.reportComment(comment: comment, user: user) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    // 백앤드에서 count만 가져올 수 있는지 찾아보자.
    func fetchCommentsCount(post: Post) -> Observable<Int> {
        return Observable.create { observer in
            self.firestoreCommentRepo.fetchComments(postID: post.postID) { result in
                switch result {
                case .success(let commentsE):
                    observer.onNext(commentsE.count)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchComments(post: Post, user: User, completion: @escaping ([Comment]) -> Void) {
        
        self.firestoreCommentRepo.fetchComments(postID: post.postID) { result in
            switch result {
            case .success(let entities):
                var newComments = [Comment]()
                let dispatchGroup = DispatchGroup()
                entities.forEach { entity in
                    dispatchGroup.enter()
                    
                    // 엔티티의 리포트 딕셔너리에 현재 이용자의 id가 있는지를 확인해야 한다.
                    guard entity.isReported[user.id] == nil else { dispatchGroup.leave()
                        return }
                    
                    self.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                        switch result {
                        case .success(let userEntity):
                            guard let userEntity = userEntity else { dispatchGroup.leave()
                                return }
                            let user = User(id: userEntity.id, image: userEntity.imageURL, nickname: userEntity.nickname, determination: userEntity.determination, priceGoal: userEntity.priceGoal, userType: UserType(rawValue: userEntity.userType) ?? .preferDineIn, dineInCount: userEntity.dineInCount, cookidsCount: userEntity.cookidsCount)
                            let didLike = entity.didLike[entity.userID] == nil
                            let newComment = Comment(commentID: entity.commentID, postID: entity.postID, parentID: entity.parentID, user: user, content: entity.content, timestamp: entity.timestamp, didLike: didLike, likes: entity.didLike.count)
                            newComments.append(newComment)
                            dispatchGroup.leave()
                        case .failure(let error):
                            dispatchGroup.leave()
                            print(error)
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.comments = newComments
                    self.commentStore.onNext(self.comments)
                    completion(newComments)
                }
            case .failure(let error):
                print(error)
                completion([])
            }
        }
        
    }
}
