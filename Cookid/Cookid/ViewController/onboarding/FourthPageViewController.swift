//
//  FourthPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class FourthPageViewController: UIViewController, ViewModelBindable, StoryboardBased {

    var coordinator: OnboardingCoordinator?
    
    var viewModel: OnboardingViewModel!
   
    @IBOutlet weak var determinationTextField: UITextField!
    @IBOutlet weak var finishPageButton: UIButton!
    @IBOutlet weak var determineStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.determineStackView.alpha = 0
        self.finishPageButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.determineStackView.alpha = 1
            self.finishPageButton.alpha = 1
        })
    }
    
    func bindViewModel() {
        
        determinationTextField.rx.text.orEmpty
            .do(onNext: { [unowned self] text in
                if viewModel.mealService.validationText(text: text) {
                    UIView.animate(withDuration: 0.5) {
                        self.finishPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        self.finishPageButton.tintColor = .systemGreen
                        self.finishPageButton.isEnabled = true

                    }
                    
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.finishPageButton.isEnabled = false
                        self.finishPageButton.tintColor = .opaqueSeparator
                    }
                }
            })
            .bind(to: viewModel.input.determination)
            .disposed(by: rx.disposeBag)
        
        finishPageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.registrationUser(completion: { (success, user) in
                    if success {
                        self?.view.window?.rootViewController?.dismiss(animated: false, completion: {
                            LocalNotificationManager.setNotification()
                            self?.setRootViewController(user: user)
                        })
                    }
                })
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    func setRootViewController(user: User) {
        
        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(mealService: viewModel.mealService, userService: viewModel.userService, shoppingService: viewModel.shoppingService))
        let mainNVC = UINavigationController(rootViewController: mainVC)
        mainVC.navigationController?.navigationBar.prefersLargeTitles = true
        mainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        
        var myMealVC = MyMealViewController.instantiate(storyboardID: "MyMealTap")
        myMealVC.bind(viewModel: MyMealViewModel(mealService: viewModel.mealService, userService: viewModel.userService))
        let myMealNVC = UINavigationController(rootViewController: myMealVC)
        myMealVC.navigationController?.navigationBar.prefersLargeTitles = true

        var myExpenseVC = MyExpenseViewController.instantiate(storyboardID: "MyExpenseTap")
        myExpenseVC.bind(viewModel: MyExpenseViewModel(mealService: viewModel.mealService, userService: viewModel.userService, shoppingService: viewModel.shoppingService))
        let myExpenseNVC = UINavigationController(rootViewController: myExpenseVC)
        myExpenseVC.navigationController?.navigationBar.prefersLargeTitles = true
        myExpenseVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC, myMealNVC, myExpenseNVC], animated: false)
        
        tabBarController.tabBar.tintColor = DefaultStyle.Color.tint
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve

        let rootVC = UIApplication.shared.windows.first!.rootViewController
        rootVC?.present(tabBarController, animated: true, completion: { [weak self] in
            self?.viewModel.userService.uploadUserInfo(user: user)
        })
    }

}
