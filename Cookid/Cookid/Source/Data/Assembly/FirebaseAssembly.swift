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
        
        container.register(StorageRepoType.self, name: nil) { resolver in
            return FirebaseStorageRepo()
        }
        
        container.register(UserRepoType.self, name: nil) { resolver in
            return FirestoreUserRepo()
        }
        
        container.register(PostRepoType.self, name: nil) { resolver in
            return FirestorePostRepo()
        }
        
        container.register(CommentRepoType.self, name: nil) { resolver in
            return FirestoreCommentRepo()
        }
    }
}
