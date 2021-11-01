//
//  MainCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class MainCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    var serviceProvider: ServiceProviderType
    
    init(parentCoordinator : CoordinatorType, serviceProvider: ServiceProviderType) {
        self.parentCoordinator = parentCoordinator
        self.serviceProvider = serviceProvider
    }
    
    func start() -> UIViewController {
        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(serviceProvider: serviceProvider))
        mainVC.coordinator = self
        navigationController = UINavigationController(rootViewController: mainVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateSelectCalendarVC(viewModel: MainViewModel) {
        var vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
        vc.bind(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddMealVC(mode: MealEditMode, meal: Meal?) {
        let vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = AddMealReactor(mode: mode, serviceProvider: serviceProvider)
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(mode: ShoppingEditMode) {
        let vc = AddShoppingViewController()
        vc.reactor = AddShoppingReactor(mode: mode, serviceProvider: serviceProvider)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddTodayMeal() {
        let vc = AddTodayMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = AddTodayReactor(serviceProvider: serviceProvider)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
