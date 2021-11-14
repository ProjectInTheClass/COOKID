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
    func updatePost(post: Post, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool>
    func deletePost(post: Post) -> Observable<Bool>
    func fetchMyPosts(user: User) -> Observable<[Post]>
    func fetchBookmarkedPosts(user: User) -> Observable<[Post]>
    func reportTransaction(currentUser: User, post: Post, isReport: Bool)
    func heartTransaction(sender: UIViewController, currentUser: User, post: Post, isHeart: Bool)
    func bookmarkTransaction(sender: UIViewController, currentUser: User, post: Post, isBookmark: Bool)
}

enum LocalUpdateMode {
    case create, update, delete
}

class PostService: BaseService, PostServiceType {
    
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
            self.repoProvider.firestorageImageRepo.uploadImages(postID: newPostID, images: images) { result in
                switch result {
                case .success(let urls):
                    let newPost = Post(postID: newPostID, user: user, images: urls, likes: 0, collections: 0, star: star, caption: caption, mealBudget: price, location: region, timeStamp: Date(), didLike: false, didCollect: false)
                    self.repoProvider.firestorePostRepo.createPost(post: newPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            self.updateLocalPosts(mode: .create, post: newPost)
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
        self.repoProvider.firestorePostRepo.fetchLatestPosts(userID: currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                var fetchedPosts = [Post]()
                let dispathGroup = DispatchGroup()
                for entity in entities {
                    dispathGroup.enter()
                    let didLike = entity.didLike.contains(currentUser.id)
                    let didCollect = entity.didCollect.contains(currentUser.id)
                    let images = entity.images.map { URL(string: $0) }
                    self.repoProvider.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                        switch result {
                        case .success(let userEntity):
                            guard let userEntity = userEntity else { return }
                            let imageURL = URL(string: userEntity.imageURL)
                            let user = User(id: userEntity.id, image: imageURL, nickname: userEntity.nickname, determination: userEntity.determination, priceGoal: userEntity.priceGoal, userType: UserType.init(rawValue: userEntity.userType) ?? .preferDineIn, dineInCount: userEntity.dineInCount, cookidsCount: userEntity.cookidsCount)
                            self.repoProvider.firestoreCommentRepo.fetchCommentsCount(postID: entity.postID) { result in
                                switch result {
                                case .success(let count):
                                    let post = Post(postID: entity.postID, user: user, images: images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: didCollect, commentCount: count)
                                    fetchedPosts.append(post)
                                    dispathGroup.leave()
                                case .failure(let error):
                                    dispathGroup.leave()
                                    print(error.rawValue)
                                }
                            }
                        case .failure(let error):
                            print(error.rawValue)
                            dispathGroup.leave()
                        }
                    }
                }
                dispathGroup.notify(queue: .global()) {
                    self.posts = fetchedPosts
                    self.postStore.onNext(self.posts)
                }
            case .failure(let error):
                print("fetchBookmarkedPosts() error - \(error)")
            }
        }
    }
    
    func fetchLastPosts(currentUser: User, completion: @escaping (Bool) -> Void) {
        print("last post")
        self.repoProvider.firestorePostRepo.fetchPastPosts(userID: currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entities):
                var fetchedPosts = [Post]()
                let dispathGroup = DispatchGroup()
                entities.forEach { entity in
                    dispathGroup.enter()
                    let didLike = entity.didLike.contains(currentUser.id)
                    let didCollect = entity.didCollect.contains(currentUser.id)
                    let images = entity.images.map { URL(string: $0) }
                    self.repoProvider.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                        switch result {
                        case .success(let userEntity):
                            guard let userEntity = userEntity else { return }
                            let imageURL = URL(string: userEntity.imageURL)
                            let user = User(id: userEntity.id, image: imageURL, nickname: userEntity.nickname, determination: userEntity.determination, priceGoal: userEntity.priceGoal, userType: UserType.init(rawValue: userEntity.userType) ?? .preferDineIn, dineInCount: userEntity.dineInCount, cookidsCount: userEntity.cookidsCount)
                            self.repoProvider.firestoreCommentRepo.fetchCommentsCount(postID: entity.postID) { result in
                                switch result {
                                case .success(let count):
                                    let post = Post(postID: entity.postID, user: user, images: images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: didCollect, commentCount: count)
                                    fetchedPosts.append(post)
                                    dispathGroup.leave()
                                case .failure(let error):
                                    dispathGroup.leave()
                                    print(error.rawValue)
                                }
                            }
                        case .failure(let error):
                            dispathGroup.leave()
                            print(error.rawValue)
                        }
                    }
                }
                dispathGroup.notify(queue: .global()) {
                    self.posts += fetchedPosts
                    let sortedPosts = self.posts.sorted(by: { $0.timeStamp > $1.timeStamp })
                    self.postStore.onNext(sortedPosts)
                    completion(true)
                }
            case .failure(let error):
                print("fetchBookmarkedPosts() error - \(error)")
            }
        }
    }
    
    func updatePost(post: Post, images: [UIImage], region: String, price: Int, star: Int, caption: String) -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestorageImageRepo.updateImages(postID: post.postID, images: images) { result in
                switch result {
                case .success(let urls):
                    let updatedPost = Post(postID: post.postID, user: post.user, images: urls, likes: post.likes, collections: post.collections, star: star, caption: caption, mealBudget: price, location: region, timeStamp: Date(), didLike: post.didLike, didCollect: post.didCollect)
                    self.repoProvider.firestorePostRepo.updatePost(updatedPost: updatedPost) { result in
                        switch result {
                        case .success(let success):
                            print(success.rawValue)
                            self.updateLocalPosts(mode: .update, post: updatedPost)
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
            self.updateLocalPosts(mode: .delete, post: post)
            self.repoProvider.firestorageImageRepo.deleteImages(postID: post.postID) { result in
                switch result {
                case .success(let success):
                    print(success.rawValue)
                    self.repoProvider.firestorePostRepo.deletePost(deletePost: post) { result in
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
    func fetchBookmarkedPosts(user: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestorePostRepo.fetchBookmarkedPosts(userID: user.id) { result in
                switch result {
                case .success(let entities):
                    var fetchedPosts = [Post]()
                    for entity in entities {
                        let didLike = entity.didLike.contains(user.id)
                        let images = entity.images.map { URL(string: $0) }
                        self.repoProvider.firestoreUserRepo.fetchUser(userID: entity.userID) { result in
                            switch result {
                            case .success(let userEntity):
                                guard let userEntity = userEntity else { return }
                                let imageURL = URL(string: userEntity.imageURL)
                                let user = User(id: userEntity.id, image: imageURL, nickname: userEntity.nickname, determination: userEntity.determination, priceGoal: userEntity.priceGoal, userType: UserType.init(rawValue: userEntity.userType) ?? .preferDineIn, dineInCount: userEntity.dineInCount, cookidsCount: userEntity.cookidsCount)
                                let post = Post(postID: entity.postID, user: user, images: images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: true)
                                fetchedPosts.append(post)
                            case .failure(let error):
                                print(error.rawValue)
                                observer.onNext([])
                            }
                        }
                    }
                    self.bookmarkedPosts = fetchedPosts
                    self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
                    observer.onNext(fetchedPosts)
                case .failure(let error):
                    print("fetchBookmarkedPosts() error - \(error)")
                }
            }
            return Disposables.create()
        }
    }
    
    @discardableResult
    func fetchMyPosts(user: User) -> Observable<[Post]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            self.repoProvider.firestorePostRepo.fetchMyPosts(userID: user.id) { result in
                switch result {
                case .success(let postEntities):
                    let dispathGroup = DispatchGroup()
                    var fetchedPosts = [Post]()
                    postEntities.forEach { entity in
                        dispathGroup.enter()
                        let didLike = entity.didLike.contains(user.id)
                        let didCollect = entity.didCollect.contains(user.id)
                        let images = entity.images.map { URL(string: $0) }
                        self.repoProvider.firestoreCommentRepo.fetchCommentsCount(postID: entity.postID) { result in
                            switch result {
                            case .success(let count):
                                let post = Post(postID: entity.postID, user: user, images: images, likes: entity.didLike.count, collections: entity.didCollect.count, star: entity.star, caption: entity.caption, mealBudget: entity.mealBudget, location: entity.location, timeStamp: entity.timestamp, didLike: didLike, didCollect: didCollect, commentCount: count)
                                fetchedPosts.append(post)
                                dispathGroup.leave()
                            case .failure(let error):
                                dispathGroup.leave()
                                print(error.rawValue)
                            }
                        }
                    }
                    dispathGroup.notify(queue: .global()) {
                        self.myPosts = fetchedPosts
                        self.myPostStore.onNext(self.myPosts)
                        observer.onNext(fetchedPosts)
                    }
                case .failure(let error):
                    print("fetchMyPosts() error" + error.rawValue)
                }
            }
            return Disposables.create()
        }
    }
    
    func reportTransaction(currentUser: User, post: Post, isReport: Bool) {
        self.updateLocalPosts(mode: .delete, post: post)
        self.repoProvider.firestorePostRepo.reportPost(userID: currentUser.id, postID: post.postID) { result in
            switch result {
            case .success(let success):
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func heartTransaction(sender: UIViewController, currentUser: User, post: Post, isHeart: Bool) {
        self.repoProvider.firestorePostRepo.heartPost(userID: currentUser.id, postID: post.postID, isHeart: isHeart) { result in
            switch result {
            case .success(let success):
                self.synchronizeAllStore(sender: sender, post: post)
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func bookmarkTransaction(sender: UIViewController, currentUser: User, post: Post, isBookmark: Bool) {
        self.repoProvider.firestorePostRepo.bookmarkPost(userID: currentUser.id, postID: post.postID, isBookmark: isBookmark) { [weak self] result in
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
                self.synchronizeAllStore(sender: sender, post: post)
                print(success.rawValue)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func synchronizeAllStore(sender: UIViewController, post: Post) {
        switch sender {
        case is PostMainViewController:
            if self.myPosts.contains(where: { $0.postID == post.postID }) {
                self.myPostStore.onNext(self.myPosts)
            }
            
            if self.bookmarkedPosts.contains(where: { $0.postID == post.postID }) {
                self.bookmarkedPostStore.onNext(self.bookmarkedPosts)
            }
        case is MyBookmarkViewController:
            if self.posts.contains(where: { $0.postID == post.postID }) {
                self.postStore.onNext(self.posts)
            }
            
            if self.myPosts.contains(where: { $0.postID == post.postID }) {
                self.myPostStore.onNext(self.myPosts)
            }
        default:
            break
        }
    }
    
    private func updateLocalPosts(mode: LocalUpdateMode, post: Post) {
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
    
}
