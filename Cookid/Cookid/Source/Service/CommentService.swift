//
//  CommentService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/14.
//

import Foundation
import RxSwift

protocol CommentServiceType {
    func createComment(comment: Comment)
    func fetchComments(post: Post, currentUser: User, completion: @escaping ([Comment]) -> Void)
    func deleteComment(comment: Comment)
    func reportComment(comment: Comment, currentUser: User)
    func fetchCommentsCount(post: Post) -> Observable<Int>
}

class CommentService: BaseService, CommentServiceType {
    
    private var comments = [Comment]()
    private lazy var commentStore = BehaviorSubject(value: comments)
    
    var currentPostComments: Observable<[Comment]> {
        return commentStore
    }
    
    func createComment(comment: Comment) {
        self.comments.append(comment)
        self.commentStore.onNext(self.comments)
        self.repoProvider.firestoreCommentRepo.createComment(comment: comment) { result in
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
        
        self.repoProvider.firestoreCommentRepo.deleteComment(comment: comment) { result in
            switch result {
            case .success(let success) :
                print(success)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func reportComment(comment: Comment, currentUser: User) {
        
        if let index = comments.firstIndex(where: { $0.commentID == comment.commentID }) {
            self.comments.remove(at: index)
            self.commentStore.onNext(self.comments)
        }
        
        self.repoProvider.firestoreCommentRepo.reportComment(comment: comment, user: currentUser) { result in
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
            self.repoProvider.firestoreCommentRepo.fetchComments(postID: post.postID) { result in
                switch result {
                case .success(let commentEntities):
                    observer.onNext(commentEntities.count)
                case .failure(let error):
                    print(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchComments(post: Post, currentUser: User, completion: @escaping ([Comment]) -> Void) {
        self.repoProvider.firestoreCommentRepo.fetchComments(postID: post.postID) { result in
            switch result {
            case .success(let entities):
                var newComments = [Comment]()
                let dispatchGroup = DispatchGroup()
                entities.forEach { entity in
                    dispatchGroup.enter()
                    
                    // 엔티티의 리포트 딕셔너리에 현재 이용자의 id가 있는지를 확인해야 한다.
                    guard entity.isReported.contains(currentUser.id) else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    self.repoProvider.firestoreUserRepo.fetchUser(userID: entity.userID) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let userEntity):
                            guard let userEntity = userEntity else {
                                dispatchGroup.leave()
                                return
                            }
                            let user = self.convertEntityToUser(entity: userEntity)
                            let newComment = self.convertEntityToComment(commentUser: user, entity: entity)
                            newComments.append(newComment)
                            dispatchGroup.leave()
                        case .failure(let error):
                            print(error)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .global()) {
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
