//
//  PostService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation
import RxSwift

class PostService {
    
    let firestoreRepo: FirestorePostRepo
    
    private var posts = [Post]()
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    init(firestoreRepo: FirestorePostRepo) {
        self.firestoreRepo = firestoreRepo
    }
    
    var currentPosts: [Post] {
        return posts
    }
    
    func createPost(post: Post) {
        firestoreRepo.createPost(post: post) { result in
            switch result {
            case .success(let result):
                print("success upload Post \(result)")
            case .failure(let error):
                print("fail upload Post \(error)")
            }
        }
        posts.append(post)
        postStore.onNext(posts)
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
    
}
