//
//  LocalSignInCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit
import Swinject

class LocalSignInCoordinator: CoordinatorType {
    
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        let userServie = assembler.resolver.resolve(UserServiceType.self)!
        let pageVC = LocalSignInViewViewController(coordinator: self, userService: userServie)
        self.navigationController.setViewControllers([pageVC], animated: false)
    }
    
    func navigateHomeCoordinator() {
        let tabBarController = assembler.resolver.resolve(UITabBarController.self)!
        self.navigationController.setViewControllers([tabBarController], animated: false)
    }
}
