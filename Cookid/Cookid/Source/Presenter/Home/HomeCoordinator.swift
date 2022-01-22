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
        
        let mainVC = assembler.resolver.resolve(MainViewController.self)!
        let mainNVC = UINavigationController(rootViewController: mainVC)
        let mainCoordinator = MainCoordinator(assembler: self.assembler, navigationController: mainNVC)
        mainVC.coordinator = mainCoordinator
        mainCoordinator.parentCoordinator = self
        childCoordinator.append(mainCoordinator)
        
        let postMainVC = assembler.resolver.resolve(PostMainViewController.self)!
        let postMainNVC = UINavigationController(rootViewController: postMainVC)
        let postCoordinator = PostCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        postMainVC.coordinator = postCoordinator
        postCoordinator.parentCoordinator = self
        childCoordinator.append(postCoordinator)
        
        let myPageVC = assembler.resolver.resolve(MyPageViewController.self)!
        let myPageNVC = UINavigationController(rootViewController: myPageVC)
        let myPageCoordinator = MyPageCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        myPageVC.coordinator = myPageCoordinator
        myPageCoordinator.parentCoordinator = self
        childCoordinator.append(myPageCoordinator)
        
        // tabbar
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC, postMainNVC, myPageNVC], animated: false)
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.tabBar.items?[0].title = "소비내역"
        tabBarController.tabBar.items?[1].title = "식사추천"
        tabBarController.tabBar.items?[2].title = "마이페이지"
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
