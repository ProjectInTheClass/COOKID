//
//  MyPageCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class MyPageCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    var serviceProvider: ServiceProviderType
    
    init(parentCoordinator : CoordinatorType, serviceProvider: ServiceProviderType) {
        self.parentCoordinator = parentCoordinator
        self.serviceProvider = serviceProvider
    }
    
    func start() -> UIViewController {
        var myPageVC = MyPageViewController.instantiate(storyboardID: "UserInfo")
        myPageVC.coordinator = self
        myPageVC.bind(viewModel: MyPageViewModel(serviceProvider: serviceProvider))
        navigationController = UINavigationController(rootViewController: myPageVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateUserInfoVC(viewModel: MyPageViewModel) {
        let userUpdateViewModel = UserInfoUpdateViewModel(serviceProvider: serviceProvider)
        var userInfoVC = UserInformationViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: userUpdateViewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(userInfoVC, animated: true, completion: nil)
    }
 
}
