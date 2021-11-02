//
//  SecondPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SecondPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: OnboardingViewModel!
    
    @IBOutlet weak var monthlyGoalStackView: UIStackView!
    @IBOutlet weak var monthlyGoal: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyGoalStackView.alpha = 0
        nextPageButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.monthlyGoalStackView.alpha = 1
        })
    }
    
    func bindViewModel() {
        
        viewModel.output.monthlyGoalValidation
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
                guard let isValid = isValid else { return }
                if isValid {
                    UIView.animate(withDuration: 0.5) {
                        owner.nextPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        owner.nextPageButton.tintColor = .systemGray
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        owner.nextPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        owner.nextPageButton.tintColor = .systemRed
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        monthlyGoal.rx.text.orEmpty
            .bind(to: viewModel.input.monthlyGoal)
            .disposed(by: rx.disposeBag)
    }
}
