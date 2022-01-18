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
        
        container.register(PhotoServiceType.self, name: nil) { resolver in
            let photoAPI = resolver.resolve(NetworkAPIType.self)!
            return PhotoService(photoAPI: photoAPI)
        }
        
        container.register(MealServiceType.self, name: nil) { resolver in
            let photoAPI = resolver.resolve(NetworkAPIType.self)!
            return MealService(repoProvider: RepositoryProvider())
        }
        
        container.register(UserServiceType.self, name: nil) { resolver in
            let photoAPI = resolver.resolve(NetworkAPIType.self)!
            return UserService(serviceProvider: ServiceProvider(), repoProvider: RepositoryProvider())
        }
    }
}
