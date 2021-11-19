//
//  LocalSignInCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit

class LocalSignInCoordinator: CoordinatorType {
    
    var parentCoordinator : CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var navigationController: UINavigationController?
    var serviceProvider: ServiceProviderType
    
    init(parentCoordinator : CoordinatorType,
         serviceProvider: ServiceProviderType) {
        self.parentCoordinator = parentCoordinator
        self.serviceProvider = serviceProvider
    }
    
    func start() -> UIViewController {
        let pageVC = LocalSignInViewViewController(coordinator: self, serviceProvider: serviceProvider)
        return pageVC
    }
    
    func navigateHomeCoordinator() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        let homeCoordinator = HomeCoordinator(parentCoordinator: appCoordinator, serviceProvider: serviceProvider)
        parentCoordinator?.childCoordinator.append(homeCoordinator)
        guard let tabBarController = homeCoordinator.start() as? UITabBarController else { return }
        let window = UIApplication.shared.windows.first!
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}