//
//  LocalSignInCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit
import Swinject

final class LocalSignInCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = assembler.resolver.resolve(LocalSignInViewViewController.self)!
        self.navigationController.setViewControllers([vc], animated: false)
    }
    
    func navigateHomeCoordinator() {
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            for coordinator in appCoordinator.childCoordinator {
                if let homeCoordinator = coordinator as? HomeCoordinator {
                    self.navigationController.popViewController(animated: false)
                    homeCoordinator.start()
                }
            }
        }
    }
}
