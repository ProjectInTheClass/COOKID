//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import Swinject

final class HomeCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        let mainCoordinator = MainCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinator.append(mainCoordinator)
        
        let mainVC = assembler.resolver.resolve(MainViewController.self)!
        mainVC.coordinator = mainCoordinator
        
        let postCoordinator = PostCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        postCoordinator.parentCoordinator = self
        childCoordinator.append(postCoordinator)
        
        let postMainVC = assembler.resolver.resolve(PostMainViewController.self)!
        postMainVC.coordinator = postCoordinator
        
        let myPageCoordinator = MyPageCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        myPageCoordinator.parentCoordinator = self
        childCoordinator.append(myPageCoordinator)
        
        let myPageVC = assembler.resolver.resolve(MyPageViewController.self)!
        myPageVC.coordinator = myPageCoordinator
        
        // tabbar
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainVC, postMainVC, myPageVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.tabBar.items?[0].title = "소비내역"
        tabBarController.tabBar.items?[1].title = "식사추천"
        tabBarController.tabBar.items?[2].title = "마이페이지"
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
