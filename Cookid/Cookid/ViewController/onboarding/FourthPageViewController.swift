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
    
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var determinationLabel: UILabel!
    @IBOutlet weak var usertypeLabel: UILabel!
    @IBOutlet weak var monthlyGoalLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func bindViewModel() {
        
        determinationTextField.rx.text.orEmpty
            .do(onNext: { [weak self] text in
                if let text = self?.determinationTextField.text,
                   !text.isEmpty {
                    self?.finishPageButton.isHidden = false
                } else {
                    self?.finishPageButton.isHidden = true
                }
            })
            .bind(to: viewModel.input.determination)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInformation
            .drive(onNext: { [weak self] user in
                self?.nicknameLabel.text = user.nickname
                self?.determinationLabel.text = user.determination
                self?.usertypeLabel.text = user.userType.rawValue
                self?.monthlyGoalLabel.text = String(user.priceGoal)
            })
            .disposed(by: rx.disposeBag)
    }
    

}
