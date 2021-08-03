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
        self.monthlyGoalStackView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.monthlyGoalStackView.alpha = 1
        })
    }
    
    func bindViewModel() {
        
        monthlyGoal.rx.text.orEmpty
            .do(onNext: { [unowned self] text in
                if viewModel.mealService.validationNum(text: text) {
                    UIView.animate(withDuration: 0.5) {
                        self.nextPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        self.nextPageButton.tintColor = .systemGreen
                    }
                    
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.nextPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        self.nextPageButton.tintColor = .red
                    }
                }
            })
            .bind(to: viewModel.input.monthlyGoal)
            .disposed(by: rx.disposeBag)
    }

}
