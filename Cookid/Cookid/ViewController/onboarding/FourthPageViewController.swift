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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func bindViewModel() {
        
        determinationTextField.rx.text.orEmpty
            .bind(to: viewModel.input.determination)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInformation
            .map { [unowned self] user -> Bool in
                return self.viewModel.vaildInformation(user.determination)
            }
            .drive(onNext: { [unowned self] validation in
                if validation {
                    self.finishPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    self.finishPageButton.tintColor = .red
                } else {
                    self.finishPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    self.finishPageButton.tintColor = .systemGreen
                }
            })
            .disposed(by: rx.disposeBag)
        
        finishPageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.registrationUser()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
       
    }


}
