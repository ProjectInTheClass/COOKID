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
        
        container.register(AddMealReactor.self, name: "new") { resolver in
            let photoService = resolver.resolve(PhotoServiceType.self)!
            let userService = resolver.resolve(UserServiceType.self)!
            let mealService = resolver.resolve(MealServiceType.self)!
            return AddMealReactor(mode: .new, photoService: photoService, userService: userService, mealService: mealService)
        }
        
        container.register(PhotoSelectViewController.self, name: nil) { resolver in
            let reactor = resolver.resolve(AddMealReactor.self)!
            let vc = PhotoSelectViewController()
            vc.reactor = reactor
            return vc
        }
    }
}
