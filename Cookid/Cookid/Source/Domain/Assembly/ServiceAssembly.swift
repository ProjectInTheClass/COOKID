//
//  ServiceAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        
        let firestorageImageRepository = safeResolver.resolve(StorageRepoType.self)!
        let firestorePostRepository = safeResolver.resolve(PostRepoType.self)!
        let firestoreCommentRepository = safeResolver.resolve(CommentRepoType.self)!
        let firestoreUserRepository = safeResolver.resolve(UserRepoType.self)!
        let realmUserRepository = safeResolver.resolve(RealmUserRepoType.self)!
        let realmShoppingRepository = safeResolver.resolve(RealmShoppingRepoType.self)!
        let realmMealRepository = safeResolver.resolve(RealmMealRepoType.self)!
        let fileManagerRepository = safeResolver.resolve(FileManagerRepoType.self)!
        let photoAPI = safeResolver.resolve(NetworkAPIType.self)!
        
        container.register(PhotoServiceType.self, name: nil) { resolver in
            return PhotoService(photoAPI: photoAPI)
        }
        
        container.register(MealServiceType.self, name: nil) { _ in
            return MealService(fileManagerRepo: fileManagerRepository, realmMealRepo: realmMealRepository, firestoreUserRepo: firestoreUserRepository)
        }.inObjectScope(.container)
        
        container.register(ShoppingServiceType.self, name: nil) { _ in
            return ShoppingService(realmShoppingRepo: realmShoppingRepository, firestoreUserRepo: firestoreUserRepository)
        }.inObjectScope(.container)
        
        container.register(UserServiceType.self, name: nil) { _ in
            return UserService(firestoreUserRepo: firestoreUserRepository, realmUserRepo: realmUserRepository, firestorageImageRepo: firestorageImageRepository)
        }.inObjectScope(.container)
        
        container.register(PostServiceType.self, name: nil) { _ in
            return PostService(firestorageImageRepo: firestorageImageRepository, firestorePostRepo: firestorePostRepository, firestoreCommentRepo: firestoreCommentRepository, firestoreUserRepo: firestoreUserRepository)
        }.inObjectScope(.container)
        
        container.register(CommentServiceType.self, name: nil) { _ in
            return CommentService(firestoreCommentRepo: firestoreCommentRepository, firestoreUserRepo: firestoreUserRepository)
        }.inObjectScope(.container)
        
    }
}
