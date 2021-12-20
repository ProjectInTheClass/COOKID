//
//  RepositoryProvider.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import Foundation
import Alamofire

protocol RepositoryProviderType : AnyObject {
    var firestorePostRepo: PostRepoType { get }
    var firestoreCommentRepo: CommentRepoType { get }
    var firestorageImageRepo: StorageImageRepo { get }
    var firestoreUserRepo: UserRepoType { get }
    var imageRepo: ImageRepoType { get }
    var realmUserRepo: RealmUserRepoType { get }
    var realmMealRepo: RealmMealRepoType { get }
    var realmShoppingRepo: RealmShoppingRepo { get }
    var afUnsplashRepo: AlamofireRepositoryType { get }
}

final class RepositoryProvider: RepositoryProviderType {
    lazy var imageRepo: ImageRepoType = ImageRepo(repoProvider: self)
    lazy var realmUserRepo: RealmUserRepoType = RealmUserRepo(repoProvider: self)
    lazy var realmMealRepo: RealmMealRepoType = RealmMealRepo(repoProvider: self)
    lazy var realmShoppingRepo: RealmShoppingRepo = RealmShoppingRepo(repoProvider: self)
    lazy var firestorePostRepo: PostRepoType = FirestorePostRepo(repoProvider: self)
    lazy var firestoreCommentRepo: CommentRepoType = FirestoreCommentRepo(repoProvider: self)
    lazy var firestorageImageRepo: StorageImageRepo = FirebaseStorageRepo(repoProvider: self)
    lazy var firestoreUserRepo: UserRepoType = FirestoreUserRepo(repoProvider: self)
    lazy var afUnsplashRepo: AlamofireRepositoryType = AFUnsplashRepo(sessionManager: Session.default)
}
