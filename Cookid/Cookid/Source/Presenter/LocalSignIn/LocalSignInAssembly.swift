//
//  LocalSignInAssembly.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import Swinject

class LocalSignInAssembly: Assembly {
    func assemble(container: Container) {
        let safeResolver = container.synchronize()
        let userService = safeResolver.resolve(UserServiceType.self)!
        // SignIn
        container.register(LocalSignInViewModel.self, name: nil) { _ in
            return LocalSignInViewModel(userService: userService)
        }
        
        container.register(LocalSignInViewViewController.self, name: nil) { _ in
            let viewModel = safeResolver.resolve(LocalSignInViewModel.self)!
            let vc = LocalSignInViewViewController(viewModel: viewModel)
            return vc
        }
    }
}
