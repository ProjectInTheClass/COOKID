//
//  OnboardingCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit

class OnboardingCoordinator: CoordinatorType {
    
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
        let pageVC = OnboardingPageViewViewController(coordinator: self, serviceProvider: serviceProvider)
        return pageVC
    }
    
    func navigateHomeCoordinator() {
        let homeCoordinator = HomeCoordinator(parentCoordinator: parentCoordinator as! AppCoordinator, serviceProvider: serviceProvider)
        parentCoordinator?.childCoordinator.append(homeCoordinator)
        guard let tabBarController = homeCoordinator.start() as? UITabBarController else { return }
        let window = UIApplication.shared.windows.first!
        window.rootViewController = tabBarController
    }
}
