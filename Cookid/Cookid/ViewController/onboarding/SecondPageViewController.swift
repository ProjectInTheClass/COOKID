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
    
    @IBOutlet weak var monthlyGoal: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nextPageButton.isHidden = true
    }
    
    func bindViewModel() {
        monthlyGoal.rx.text.orEmpty
            .do(onNext: { [weak self] text in
                if let text = self?.monthlyGoal.text,
                   !text.isEmpty {
                    self?.nextPageButton.isHidden = false
                } else {
                    self?.nextPageButton.isHidden = true
                }
            })
            .map({ str in
                return 1000
            })
            .bind(to: viewModel.input.monthlyGoal)
            .disposed(by: rx.disposeBag)
    }

}
