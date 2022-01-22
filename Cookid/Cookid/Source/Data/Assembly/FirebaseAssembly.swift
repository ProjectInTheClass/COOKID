//
//  FirebaseAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/19.
//

import Foundation
import Swinject

class FirebaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StorageRepoType.self, name: nil) { _ in
            return FirebaseStorageRepo()
        }
        
        container.register(UserRepoType.self, name: nil) { _ in
            return FirestoreUserRepo()
        }
        
        container.register(PostRepoType.self, name: nil) { _ in
            return FirestorePostRepo()
        }.inObjectScope(.container)
        
        container.register(CommentRepoType.self, name: nil) { _ in
            return FirestoreCommentRepo()
        }
    }
}
