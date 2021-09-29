//
//  PostService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import Foundation
import RxSwift

class PostService {
    
    private var posts = DummyData.shared.posts
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    func createPost(post: Post) {
        print("createPost completion")
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
