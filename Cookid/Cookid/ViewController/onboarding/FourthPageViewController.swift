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
                if viewModel.validationText(text: text) {
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
                
                // 여기 살펴보자.
                self?.viewModel.registrationUser()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
       
    }


}
