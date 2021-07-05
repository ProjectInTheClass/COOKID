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

class FourthPageViewController: UIViewController, ViewModelBindable {
    
    var viewModel: OnboardingViewModel!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var determinationLabel: UILabel!
    @IBOutlet weak var usertypeLabel: UILabel!
    @IBOutlet weak var monthlyGoalLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func bindViewModel() {
        
        viewModel.output.userInformation
            .subscribe(onNext: { [weak self] user in
                self?.nicknameLabel.text = user.nickname
                self?.determinationLabel.text = user.determination
                self?.monthlyGoalLabel.text = String(user.priceGoal)
            })
            .disposed(by: rx.disposeBag)
    }
    

}
