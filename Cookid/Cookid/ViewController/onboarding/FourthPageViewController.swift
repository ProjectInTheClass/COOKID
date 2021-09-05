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
    
    var user: User?

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
        if coordinator != nil {
            print("no nil!!!!!!!!!")
        } else {
            print("nil!!!!!!!!!")
        }
    }
    
    deinit {
        print("Fourpage Deinit")
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
        
        viewModel.output.userInformation
            .subscribe(onNext: { [unowned self] user in
                self.user = user
            })
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func finish(_ sender: Any) {
        guard let user = self.user else { return }
        self.setRootViewController(user: user)
    }
    
    // forced unwrapping
    func setRootViewController(user: User) {
        guard let tabBarController = coordinator?.parentCoordinator?.navigateHomeCoordinator() as? UITabBarController else { return }
        guard let nvc = tabBarController.viewControllers?[0] as? UINavigationController else { return }
        guard let vc = nvc.topViewController as? MainViewController else { return }
        let vm = vc.viewModel!
        let window = UIApplication.shared.windows.first!
        window.rootViewController = tabBarController
        vm.userService.uploadUserInfo(user: user)
    }

}
