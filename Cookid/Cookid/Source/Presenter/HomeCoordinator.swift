//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/11.
//

import UIKit
import Swinject

final class HomeCoordinator: CoordinatorType {
    
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
      
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
