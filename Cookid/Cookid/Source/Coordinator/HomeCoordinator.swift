//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit

class HomeCoordinator: CoordinatorType {
    
    var parentCoordinator : CoordinatorType
    var childCoordinator: [CoordinatorType] = []
    var serviceProvider: ServiceProviderType
    var navigationController: UINavigationController?

    init(parentCoordinator : CoordinatorType,
         serviceProvider: ServiceProviderType) {
        self.parentCoordinator = parentCoordinator
        self.serviceProvider = serviceProvider
    }
    
    func start() -> UIViewController {
      
        let mainCoordinator = MainCoordinator(parentCoordinator: self, serviceProvider: serviceProvider)
        let mainNVC = mainCoordinator.start()
        childCoordinator.append(mainCoordinator)
        
        let postCoordinator = PostCoordinator(parentCoordinator: self, serviceProvider: serviceProvider)
        let postNVC = postCoordinator.start()
        childCoordinator.append(postCoordinator)
        
        let myPageCoordinator = MyPageCoordinator(parentCoordinator: self, serviceProvider: serviceProvider)
        let myPageNVC = myPageCoordinator.start()
        childCoordinator.append(myPageCoordinator)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC, postNVC, myPageNVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.tabBar.items?[2].title = "마이페이지"
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        return tabBarController
    }
    
}
