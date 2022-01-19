//
//  AppCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit
import Swinject

final class AppCoordinator: CoordinatorType {
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        let realmUserRepo = assembler.resolver.resolve(RealmUserRepoType.self)!
        if realmUserRepo.fetchUser() != nil {
            let mainCoordinator = MainCoordinator(assembler: self.assembler, navigationController: self.navigationController)
            mainCoordinator.start()
        } else {
            let localSignInCoordinator = LocalSignInCoordinator(assembler: self.assembler, navigationController: self.navigationController)
            localSignInCoordinator.start()
        }
    }
}
