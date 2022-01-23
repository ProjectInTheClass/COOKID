//
//  HomeCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import Foundation
import Swinject
import UIKit

final class HomeCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController?
    
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    private func configureNavigationController() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func start() {
        
        configureNavigationController()
        
        let mainVC = assembler.resolver.resolve(MainViewController.self)!
        let mainNVC = UINavigationController(rootViewController: mainVC)
        mainNVC.navigationBar.prefersLargeTitles = true
        let mainCoordinator = MainCoordinator(assembler: self.assembler)
        mainCoordinator.navigationController = mainNVC
        mainVC.coordinator = mainCoordinator
        mainCoordinator.parentCoordinator = self
        childCoordinator.append(mainCoordinator)
        
        let postMainVC = assembler.resolver.resolve(PostMainViewController.self)!
        let postMainNVC = UINavigationController(rootViewController: postMainVC)
        postMainNVC.navigationBar.prefersLargeTitles = false
        let postCoordinator = PostCoordinator(assembler: self.assembler)
        postCoordinator.navigationController = postMainNVC
        postMainVC.coordinator = postCoordinator
        postCoordinator.parentCoordinator = self
        childCoordinator.append(postCoordinator)
        
        let myPageVC = assembler.resolver.resolve(MyPageViewController.self)!
        let myPageNVC = UINavigationController(rootViewController: myPageVC)
        let myPageCoordinator = MyPageCoordinator(assembler: self.assembler)
        myPageCoordinator.navigationController = myPageNVC
        myPageVC.coordinator = myPageCoordinator
        myPageNVC.navigationBar.prefersLargeTitles = false
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
        self.navigationController?.setViewControllers([tabBarController], animated: false)
    }
    
}
