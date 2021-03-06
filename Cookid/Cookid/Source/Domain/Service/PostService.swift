//
//  PostService.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/11.
//

import UIKit
import RxSwift
import Kingfisher

protocol PostServiceType {
    var postsCount: Observable<Int> { get }
    var totalPosts: Observable<[Post]> { get }
    var myTotalPosts: Observable<[Post]> { get }
    var bookmaredTotalPosts: Observable<[Post]> { get }
    func createPost(user: User, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool>
    func fetchLatestPosts(currentUser: User)
    func fetchLastPosts(currentUser: User, completion: @escaping (Bool) -> Void)
    func updatePost(originalPost: Post, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool>
    func deletePost(post: Post) -> Observable<Bool>
    func fetchMyPosts(currentUser: User) -> Observable<[Post]>
    func fetchBookmarkedPosts(currentUser: User) -> Observable<[Post]>
    func reportTransaction(currentUser: User, post: Post, isReport: Bool)
    func heartTransaction(sender: UIViewController, currentUser: User, post: Post, isHeart: Bool)
    func bookmarkTransaction(sender: UIViewController, currentUser: User, post: Post, isBookmark: Bool)
}

enum LocalUpdateMode {
    case create, update, delete
}

class PostService: BaseService, PostServiceType {
    
    let firestorageImageRepo: StorageRepoType
    let firestorePostRepo: PostRepoType
    let firestoreCommentRepo: CommentRepoType
    let firestoreUserRepo: UserRepoType
    init(firestorageImageRepo: StorageRepoType,
         firestorePostRepo: PostRepoType,
         firestoreCommentRepo: CommentRepoType,
         firestoreUserRepo: UserRepoType) {
        self.firestorageImageRepo = firestorageImageRepo
        self.firestorePostRepo = firestorePostRepo
        self.firestoreCommentRepo = firestoreCommentRepo
        self.firestoreUserRepo = firestoreUserRepo
    }
    
    private var posts = [Post]()
    private lazy var postStore = BehaviorSubject<[Post]>(value: posts)
    
    private var myPosts = [Post]()
    private lazy var myPostStore = BehaviorSubject<[Post]>(value: myPosts)
    
    private var bookmarkedPosts = [Post]()
    private lazy var bookmarkedPostStore = BehaviorSubject<[Post]>(value: bookmarkedPosts)
    
    var postsCount: Observable<Int> {
        return postStore.map { $0.count }
    }
    
    var totalPosts: Observable<[Post]> {
        return postStore.map { $0.sorted(by: { $0.timeStamp > $1.timeStamp })}
    }
    
    var myTotalPosts: Observable<[Post]> {
        return myPostStore
    }
    
    var bookmaredTotalPosts: Observable<[Post]> {
        return bookmarkedPostStore
    }
    
    func createPost(user: User, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let newPostID = UUID().uuidString
            self.firestorageImageRepo.uploadImages(postID: newPostID, images: images) { result in
                switch result {
                case .success(let urls):
                    let newPost = Post(postID: newPostID, user: user, images: urls, star: star, caption: caption, mealBudget: price, location: region)
                    self.firestorePostRepo.createPost(post: newPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            self.updateMemoryPosts(mode: .create, post: newPost)
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
    
    func fetchLatestPosts(currentUser: User) {
        self.firestorePostRepo.fetchLatestPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                self.makePostsWithFetchedEntity(postEntities: entities, currentUser: currentUser) { posts in
                    self.posts = posts
                    self.postStore.onNext(self.posts)
                }
            case .failure(let error):
                print("fetch Latest Posts error \(error)")
            }
        }
    }
    
    func fetchLastPosts(currentUser: User, completion: @escaping (Bool) -> Void) {
        self.firestorePostRepo.fetchPastPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                
                guard entities.count > 0 else {
                    completion(true)
                    return
                }
                
                self.makePostsWithFetchedEntity(postEntities: entities, currentUser: currentUser) { posts in
                    self.posts += posts
                    let sortedPosts = self.posts.sorted(by: { $0.timeStamp > $1.timeStamp })
                    self.postStore.onNext(sortedPosts)
                    completion(true)
                }
                
            case .failure(let error):
                print("fetch Last Posts error \(error)")
                completion(false)
            }
        }
    }
    
    func updatePost(originalPost: Post, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestorageImageRepo.updateImages(postID: originalPost.postID, images: images) { result in
                switch result {
                case .success(let urls):
                    let updatedPost = Post(postID: originalPost.postID, user: originalPost.user, images: urls, likes: originalPost.likes, collections: originalPost.collections, star: star, caption: caption, mealBudget: price, location: region, timeStamp: originalPost.timeStamp, didLike: originalPost.didLike, didCollect: originalPost.didCollect)
                    self.firestorePostRepo.updatePost(updatedPost: updatedPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            self.updateMemoryPosts(mode: .update, post: updatedPost)
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
            self.updateMemoryPosts(mode: .delete, post: post)
            self.firestorageImageRepo.deleteImages(postID: post.postID) { result in
                switch result {
                case .success(let success):
                    print(success.rawValue)
                    self.firestorePostRepo.deletePost(deletePost: post) { result in
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
                    print("delete Post Error : \(error)")
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func fetchBookmarkedPosts(currentUser: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestorePostRepo.fetchBookmarkedPosts(userID: currentUser.id) { result in
                switch result {
                case .success(let entities):
                    self.makePostsWithFetchedEntity(postEntities: entities, currentUser: currentUser) { posts in
                        self.bookmarkedPosts = posts
                        self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
                        observer.onNext(posts)
                    }
                case .failure(let error):
                    print("fetchBookmarkedPosts() error - \(error)")
                }
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func fetchMyPosts(currentUser: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.firestorePostRepo.fetchMyPosts(userID: currentUser.id) { result in
                switch result {
                case .success(let postEntities):
                    let dispathGroup = DispatchGroup()
                    var fetchedPosts = [Post]()
                    postEntities.forEach { entity in
                        dispathGroup.enter()
                        self.firestoreCommentRepo.fetchCommentsCount(postID: entity.postID) { result in
                            switch result {
                            case .success(let count):
                                let post = self.convertEntityToPost(entity: entity, currentUser: currentUser, postUser: currentUser, commentsCount: count)
                                fetchedPosts.append(post)
                                dispathGroup.leave()
                            case .failure(let error):
                                print(error.rawValue)
                                dispathGroup.leave()
                            }
                        }
                    }
                    dispathGroup.notify(queue: .global()) {
                        self.myPosts = fetchedPosts
                        self.myPostStore.onNext(self.myPosts)
                        observer.onNext(fetchedPosts)
                    }
                case .failure(let error):
                    print("fetc hMyPosts error" + error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    func reportTransaction(currentUser: User, post: Post, isReport: Bool) {
        self.updateMemoryPosts(mode: .delete, post: post)
        self.firestorePostRepo.reportPost(userID: currentUser.id, postID: post.postID) { result in
            switch result {
            case .success(let success):
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func heartTransaction(sender: UIViewController, currentUser: User, post: Post, isHeart: Bool) {
        self.synchronizeAllStore(sender: sender, post: post, bookheart: false)
        self.firestorePostRepo.heartPost(userID: currentUser.id, postID: post.postID, isHeart: isHeart) { result in
            switch result {
            case .success(let success):
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func bookmarkTransaction(sender: UIViewController, currentUser: User, post: Post, isBookmark: Bool) {
        self.synchronizeAllStore(sender: sender, post: post, bookheart: true)
        self.firestorePostRepo.bookmarkPost(userID: currentUser.id, postID: post.postID, isBookmark: isBookmark) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if isBookmark {
                    self.bookmarkedPosts.append(post)
                    self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
                } else {
                    if let index = self.bookmarkedPosts.firstIndex(where: { $0.postID == post.postID }) {
                        self.bookmarkedPosts.remove(at: index)
                        self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
                    }
                }
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func synchronizeAllStore(sender: UIViewController, post: Post, bookheart: Bool) {
        switch sender {
        case is PostMainViewController:
            if let myPost = self.myPosts.first(where: { $0.postID == post.postID }) {
                bookheart ? myPost.bookmark() : myPost.like()
                self.myPostStore.onNext(self.myPosts)
            }
            
            if let bookmarkPost = self.bookmarkedPosts.first(where: { $0.postID == post.postID }) {
                bookheart ? bookmarkPost.bookmark() : bookmarkPost.like()
                self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
            }
        case is MyBookmarkViewController:
            if let post = self.posts.first(where: { $0.postID == post.postID }) {
                bookheart ? post.bookmark() : post.like()
                self.postStore.onNext(self.posts)
            }
            
            if let myPost = self.myPosts.first(where: { $0.postID == post.postID }) {
                bookheart ? myPost.bookmark() : myPost.like()
                self.myPostStore.onNext(self.myPosts)
            }
        default:
            break
        }
    }
    
    private func updateMemoryPosts(mode: LocalUpdateMode, post: Post) {
        switch mode {
        case .create:
            self.posts.append(post)
            self.myPosts.append(post)
        case .update:
            if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                self.posts.remove(at: index)
                self.posts.insert(post, at: index)
            }
            
            if let myIndex = self.myPosts.firstIndex(where: { $0.postID == post.postID }) {
                self.myPosts.remove(at: myIndex)
                self.myPosts.insert(post, at: myIndex)
            }
            
            if let bookmarkIndex = self.bookmarkedPosts.firstIndex(where: { $0.postID == post.postID }) {
                self.bookmarkedPosts.remove(at: bookmarkIndex)
                self.bookmarkedPosts.insert(post, at: bookmarkIndex)
            }
        case .delete:
            if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                self.posts.remove(at: index)
            }
            
            if let myIndex = self.myPosts.firstIndex(where: { $0.postID == post.postID }) {
                self.myPosts.remove(at: myIndex)
            }
            
            if let bookmarkIndex = self.bookmarkedPosts.firstIndex(where: { $0.postID == post.postID }) {
                self.bookmarkedPosts.remove(at: bookmarkIndex)
            }
        }
        self.postStore.onNext(self.posts)
        self.myPostStore.onNext(self.myPosts)
        self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
    }
    
    private func makePostsWithFetchedEntity(postEntities: [PostEntity], currentUser: User, completion: @escaping ([Post]) -> Void) {
        var fetchedPosts = [Post]()
        let dispatchGroup = DispatchGroup()
        postEntities.forEach { entity in
            dispatchGroup.enter()
            
            guard !entity.isReported.contains(currentUser.id) else {
                dispatchGroup.leave()
                return
            }
            
            self.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                switch result {
                case .success(let userEntity):
                    guard let userEntity = userEntity else {
                        dispatchGroup.leave()
                        return
                    }
                    let postUser = self.convertEntityToUser(entity: userEntity)
                    self.firestoreCommentRepo.fetchCommentsCount(postID: entity.postID) { result in
                        switch result {
                        case .success(let count):
                            let post = self.convertEntityToPost(entity: entity, currentUser: currentUser, postUser: postUser, commentsCount: count)
                            fetchedPosts.append(post)
                            dispatchGroup.leave()
                        case .failure(let error):
                            dispatchGroup.leave()
                            print(error.rawValue)
                        }
                    }
                case .failure(let error):
                    print(error.rawValue)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(fetchedPosts)
        }
    }
}
