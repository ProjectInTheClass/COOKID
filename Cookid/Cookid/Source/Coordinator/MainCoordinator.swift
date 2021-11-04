//
//  MainCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit
import ReactorKit

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
    
    func navigateAddMealVC(mode: MealEditMode) {
        let vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = AddMealReactor(mode: mode, serviceProvider: serviceProvider)
        vc.coordinator = self
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(mode: ShoppingEditMode) {
        let vc = AddShoppingViewController()
        vc.reactor = AddShoppingReactor(mode: mode, serviceProvider: serviceProvider)
        vc.coordinator = self
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
    
    func presentDeleteAlert(root: UIViewController, reactor: AddShoppingReactor) {
        let alert = UIAlertController(title: "삭제하기", message: "식사를 삭제하시겠어요? 삭제 후에는 복구가 불가능합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .default) { _ in
            switch reactor.mode {
            case .edit(_):
                reactor.action.onNext(.deleteButtonTapped)
            default:
                break
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        root.present(alert, animated: true)
    }
    
}
