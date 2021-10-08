//
//  PostService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
import RxSwift
import Kingfisher

class PostService {
    
    let firestorePostRepo: FirestorePostRepo
    let firebaseStorageRepo: FirebaseStorageRepo
    let firestoreUserRepo: FirestoreUserRepo
    
    private var posts = [Post]()
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    init(firestoreRepo: FirestorePostRepo, firebaseStorageRepo: FirebaseStorageRepo, firestoreUserRepo: FirestoreUserRepo) {
        self.firestorePostRepo = firestoreRepo
        self.firebaseStorageRepo = firebaseStorageRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    var postsCount: Observable<Int> {
        return postStore.map { $0.count }
    }
    
    func myPosts(user: User) -> Observable<[Post]> {
        return postStore.map { $0.filter { $0.user.id ==  user.id } }
    }
    
    var totlaPosts: Observable<[Post]> {
        return postStore
    }
    
    func createPost(user: User, images: [UIImage], postValue: PostValue) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let newPostID = UUID().uuidString
            self.firebaseStorageRepo.uploadImages(postID: newPostID, images: images) { result in
                switch result {
                case .success(let urls):
                    let newPost = Post(postID: newPostID, user: user, images: urls, likes: 0, collections: 0, star: postValue.star, caption: postValue.caption, mealBudget: postValue.price, location: postValue.region, timeStamp: Date(), didLike: false, didCollect: false)
                    self.firestorePostRepo.createPost(post: newPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            self.posts.append(newPost)
                            self.postStore.onNext(self.posts)
                            observer.onNext(true)
                        case .failure(let error):
                            print(error.rawValue)
                            observer.onNext(false)
                        }
                    }
                case .failure(let error):
                    print(error.rawValue)
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func fetchPosts(currentUser: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestorePostRepo.fetchPosts(userID: currentUser.id) {  result in
                switch result {
                case .success(let entities):
                    var fetchedPosts = [Post]()
                    for entity in entities {
                        let didLike = entity.didLike.contains { $0.key == currentUser.id }
                        let didCollect = entity.didCollect.contains { $0.key == currentUser.id }
                        self.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                            switch result {
                            case .success(let userEntity):
                                let user = userEntity.map { User(id: $0.id, image: $0.imageURL, nickname: $0.nickname, determination: $0.determination, priceGoal: $0.priceGoal, userType: UserType.init(rawValue: $0.userType) ?? .preferDineIn, dineInCount: $0.dineInCount, cookidsCount: $0.cookidsCount) }
                                let post = Post(postID: entity.postID, user: user!, images: entity.images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: didCollect)
                                fetchedPosts.append(post)
                            case .failure(let error):
                                print(error.rawValue)
                                observer.onNext([])
                            }
                        }
                    }
                    self.posts += fetchedPosts
                    self.postStore.onNext(self.posts)
                    observer.onNext(fetchedPosts)
                case .failure(let error):
                    print("fetchBookmarkedPosts() error - \(error)")
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
    
    func updatePost(post: Post, images: [UIImage], postValue: PostValue) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firebaseStorageRepo.updateImages(postID: post.postID, images: images) { result in
                switch result {
                case .success(let urls):
                    let updatedPost = Post(postID: post.postID, user: post.user, images: urls, likes: post.likes, collections: post.collections, star: postValue.star, caption: postValue.caption, mealBudget: postValue.price, location: postValue.region, timeStamp: Date(), didLike: post.didLike, didCollect: post.didCollect)
                    self.firestorePostRepo.updatePost(updatedPost: updatedPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                                self.posts.remove(at: index)
                                self.posts.insert(post, at: index)
                                self.postStore.onNext(self.posts)
                            }
                            observer.onNext(true)
                        case .failure(let error):
                            print(error.rawValue)
                            observer.onNext(false)
                        }
                    }
                case .failure(let error):
                    print(error.rawValue)
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func deletePost(post: Post) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firebaseStorageRepo.deleteImages(postID: post.postID) { result in
                switch result {
                case .success(let success):
                    print(success.rawValue)
                    self.firestorePostRepo.deletePost(deletePost: post) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                                self.posts.remove(at: index)
                                self.postStore.onNext(self.posts)
                                observer.onNext(true)
                            }
                        case .failure(let error):
                            print(error.rawValue)
                            observer.onNext(false)
                        }
                    }
                case .failure(let error):
                    print("delete Post Error : \(error)")
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchBookmarkedPosts(user: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestorePostRepo.fetchBookmarkedPosts(user: user) { result in
                switch result {
                case .success(let postEntities):
                    let bookmarkedPosts = postEntities.map { entity -> Post in
                        let didLike = entity.didLike.contains { $0.key == user.id }
                        return Post(postID: entity.postID, user: user, images: entity.images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: true)
                    }
                    observer.onNext(bookmarkedPosts)
                case .failure(let error):
                    print("fetchBookmarkedPosts() error - \(error)")
                    observer.onNext([])
                }
            }
            return Disposables.create()
        }
    }
    
    func heartTransaction(isSelect: Bool) {
        print(isSelect)
    }
    
    func bookmarkTransaction(isSelect: Bool) {
        print(isSelect)
    }
    
}
