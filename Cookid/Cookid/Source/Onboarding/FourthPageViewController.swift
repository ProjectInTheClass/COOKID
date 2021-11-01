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
    
    deinit {
        print("Fourpage Deinit")
    }
    
    func bindViewModel() {
        viewModel.output.determinationValidation
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
                guard let isValid = isValid else { return }
                if isValid {
                    UIView.animate(withDuration: 0.5) {
                        owner.finishPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        owner.finishPageButton.tintColor = .systemGreen
                        owner.finishPageButton.isEnabled = true
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        owner.finishPageButton.isEnabled = false
                        owner.finishPageButton.tintColor = .opaqueSeparator
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.isError
            .withUnretained(self)
            .bind(onNext: { owner, isError in
                guard let isError = isError else { return }
                if isError {
                    errorAlert(selfView: owner, errorMessage: "등록에 실패했습니다. 다시 시도해 주세요.", completion: {  })
                } else {
                    owner.coordinator?.navigateHomeCoordinator()
                }
            })
            .disposed(by: rx.disposeBag)
        
        determinationTextField.rx.text.orEmpty
            .bind(to: viewModel.input.determination)
            .disposed(by: rx.disposeBag)
        
        finishPageButton.rx.tap
            .bind(to: viewModel.input.completeButtonTapped)
            .disposed(by: rx.disposeBag)
    }
}
