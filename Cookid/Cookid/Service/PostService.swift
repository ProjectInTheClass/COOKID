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
    
    let firestoreRepo: FirestorePostRepo
    let firebaseStorageRepo: FirebaseStorageRepo
    
    private var posts = [Post]()
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    init(firestoreRepo: FirestorePostRepo, firebaseStorageRepo: FirebaseStorageRepo) {
        self.firestoreRepo = firestoreRepo
        self.firebaseStorageRepo = firebaseStorageRepo
    }
    
    var postsCount: Observable<Int> {
        return postStore.map { $0.count }
    }
    
    func myPosts(user: User) -> Observable<[Post]> {
        return postStore.map { $0.filter { $0.user.id ==  user.id } }
    }
    
    func createPost(user: User, images: [UIImage], postValue: PostValue) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let viewPostID = UUID().uuidString
            self.firebaseStorageRepo.uploadImages(postID: viewPostID, images: images) { result in
                switch result {
                case .success(let urls):
                    let newPost = Post(postID: viewPostID, user: user, images: urls, likes: 0, collections: 0, star: postValue.star, caption: postValue.caption, mealBudget: postValue.price, location: postValue.region, timeStamp: Date(), didLike: false, didCollect: false)
                    self.firestoreRepo.createPost(post: newPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
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
    
    func fetchPosts() -> Observable<[Post]> {
        print("fetch posts")
        postStore.onNext(posts)
        return postStore
    }
    
    func updatePost(post: Post) {
        FirestorePostRepo.instance.updatePost(updatedPost: post)
        if let index = posts.firstIndex(where: { $0.postID == post.postID }) {
            posts.remove(at: index)
            posts.insert(post, at: index)
        }
    }
    
    func fetchBookmarkedPosts(user: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestoreRepo.fetchBookmarkedPosts(user: user) { result in
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
