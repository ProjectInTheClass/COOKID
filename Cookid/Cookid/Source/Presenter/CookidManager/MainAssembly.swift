//
//  MainAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/18.
//

import Foundation
import Swinject

class MainAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        
        container.register(NetworkAPIType.self, name: nil) { resolver in
            return PhotoAPI()
        }
        
        container.register(PhotoServiceType.self, name: nil) { resolver in
            let photoAPI = resolver.resolve(NetworkAPIType.self)!
            return PhotoService(photoAPI: photoAPI)
        }
        
        container.register(AddMealReactor.self, name: "new") { resolver in
            let photoService = resolver.resolve(PhotoServiceType.self)!
            return AddMealReactor(mode: .new, photoService: <#T##PhotoServiceType#>, userService: <#T##UserServiceType#>, mealService: <#T##MealServiceType#>)
        }
        
    }
}
