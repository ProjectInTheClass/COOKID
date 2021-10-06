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
        return Observable.create { observer in
//            FirestorePostRepo.instance.fetchBookmarkedPosts(user: user) { result in
//                switch result {
//                case .success(let entities):
//
//                    let posts = entities.map {
//                        var images = [UIImage]()
//                        $0.images.forEach { self.urlToImageWithKingFisher(url: $0, completion: { image in
//                            guard let image = image else { return }
//                            images.append(image)
//                        })}
//
//                        Post(postID: $0.postID, user: $0.userID, images: images, likes: $0.didLike.count, collections: $0.didCollect.count, star: $0, caption: <#T##String#>, mealBudget: <#T##Int#>, location: <#T##String#>, timeStamp: <#T##Date#>, didLike: <#T##Bool#>, didCollect: <#T##Bool#>) }
//                case .failure(let error):
//                    print("PostService - fetchBookmarkedPosts() - \(error)")
//                    return
//                }
//            }
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
