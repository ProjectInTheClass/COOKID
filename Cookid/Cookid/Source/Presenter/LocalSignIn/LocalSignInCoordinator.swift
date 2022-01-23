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
    var navigationController: UINavigationController?
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func start() {
        let vc = assembler.resolver.resolve(LocalSignInViewViewController.self)!
        vc.coordinator = self
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func navigateHomeCoordinator() {
        if let appCoordinator = parentCoordinator as? AppCoordinator {
            appCoordinator.start()
        }
    }
}
