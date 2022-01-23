//
//  AppCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit
import Swinject

final class AppCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController? = UINavigationController()
    var window: UIWindow?
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func start() {
        let realmUserRepo = assembler.resolver.resolve(RealmUserRepoType.self)!
        if realmUserRepo.fetchUser() != nil {
            let homeCoordinator = HomeCoordinator(assembler: self.assembler)
            homeCoordinator.navigationController = navigationController
            homeCoordinator.parentCoordinator = self
            childCoordinator.append(homeCoordinator)
            homeCoordinator.start()
        } else {
            let localSignInCoordinator = LocalSignInCoordinator(assembler: self.assembler)
            localSignInCoordinator.navigationController = navigationController
            localSignInCoordinator.parentCoordinator = self
            childCoordinator.append(localSignInCoordinator)
            localSignInCoordinator.start()
        }
        window?.tintColor = DefaultStyle.Color.labelTint
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
