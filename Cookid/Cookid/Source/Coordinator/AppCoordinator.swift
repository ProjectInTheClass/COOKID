//
//  AppCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit

class AppCoordinator: CoordinatorType {
    
    var childCoordinator = [CoordinatorType]()
    var navigationController: UINavigationController?
    let repoProvider: RepositoryProviderType
    var serviceProvider: ServiceProviderType
    
    init(serviceProvider: ServiceProviderType,
         repoProvider: RepositoryProviderType) {
        self.serviceProvider = serviceProvider
        self.repoProvider = repoProvider
    }
    
    // MARK: - START
    
    func start() -> UIViewController {
        if repoProvider.realmUserRepo.fetchUser() != nil {
            let homeCoordinator = HomeCoordinator(parentCoordinator: self, serviceProvider: serviceProvider)
            childCoordinator.append(homeCoordinator)
            return homeCoordinator.start()
        } else {
            let onBoardingCoordinator = OnboardingCoordinator(parentCoordinator: self, serviceProvider: serviceProvider)
            childCoordinator.append(onBoardingCoordinator)
            return onBoardingCoordinator.start()
        }
    }
}
