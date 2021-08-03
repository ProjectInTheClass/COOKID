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
                            self?.setRootViewController(user: user)
                        })
                    }
                })
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    func setRootViewController(user: User) {
        let mealRepo = MealRepository()
        let userRepo = UserRepository()
        let groceryRepo = GroceryRepository()

        let mealService = MealService(mealRepository: mealRepo, userRepository: userRepo, groceryRepository: groceryRepo)
        let userService = UserService(userRepository: userRepo)
        let shoppingService = ShoppingService(groceryRepository: groceryRepo)

        var mainVC = MainViewController.instantiate(storyboardID: "Main")
        mainVC.bind(viewModel: MainViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        let mainNVC = UINavigationController(rootViewController: mainVC)
        mainVC.navigationController?.navigationBar.prefersLargeTitles = true

        var myMealVC = MyMealViewController.instantiate(storyboardID: "MyMealTap")
        myMealVC.bind(viewModel: MyMealViewModel(mealService: mealService, userService: userService))
        let myMealNVC = UINavigationController(rootViewController: myMealVC)
        myMealVC.navigationController?.navigationBar.prefersLargeTitles = true

        var myExpenseVC = MyExpenseViewController.instantiate(storyboardID: "MyExpenseTap")
        myExpenseVC.bind(viewModel: MyExpenseViewModel(mealService: mealService, userService: userService, shoppingService: shoppingService))
        let myExpenseNVC = UINavigationController(rootViewController: myExpenseVC)
        myExpenseVC.navigationController?.navigationBar.prefersLargeTitles = true

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([mainNVC, myMealNVC, myExpenseNVC], animated: false)
        tabBarController.tabBar.tintColor = .black
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        
        let rootVC = UIApplication.shared.windows.first!.rootViewController
        rootVC?.present(tabBarController, animated: true, completion: {
            userService.uploadUserInfo(user: user)
        })
    }
    
    
    private func setNotification(){
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "새로운 달입니다!"
        content.body = "새로운 가계부 진행시켜 🏃‍♀️"
        
        var datComp = DateComponents()
        datComp.day = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
