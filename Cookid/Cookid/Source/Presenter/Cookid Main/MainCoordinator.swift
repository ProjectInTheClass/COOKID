//
//  MainCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit
import ReactorKit
import Swinject

final class MainCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    private func navigationBarConfigure() {
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateSelectCalendarVC(viewModel: MainViewModel) {
        var vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
        vc.bind(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddMealVC(mode: MealEditMode) {
        let vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = assembler.resolver.resolve(AddMealReactor.self, argument: mode)!
        vc.coordinator = self
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddShoppingVC(mode: ShoppingEditMode) {
        let vc = assembler.resolver.resolve(AddShoppingViewController.self, argument: mode)!
        vc.coordinator = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func navigateAddTodayMeal() {
        let vc = assembler.resolver.resolve(AddTodayMealViewController.self)!
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true, completion: nil)
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
