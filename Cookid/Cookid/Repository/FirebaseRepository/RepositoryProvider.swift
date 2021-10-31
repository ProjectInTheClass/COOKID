//
//  RepositoryProvider.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/30.
//

import Foundation

protocol RepositoryProviderType : AnyObject {
    var firestorePostRepo: PostRepoType { get }
    var firestoreCommentRepo: CommentRepoType { get }
    var firestorageImageRepo: StorageImageRepo { get }
    var firestoreUserRepo: UserRepoType { get }
}

final class RepositoryProvider: RepositoryProviderType {
    lazy var firestorePostRepo: PostRepoType = FirestorePostRepo(repoProvider: self)
    lazy var firestoreCommentRepo: CommentRepoType = FirestoreCommentRepo(repoProvider: self)
    lazy var firestorageImageRepo: StorageImageRepo = FirebaseStorageRepo(repoProvider: self)
    lazy var firestoreUserRepo: UserRepoType = FirestoreUserRepo(repoProvider: self)
}
