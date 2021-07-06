//
//  FirstPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class FirstPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
   
    var viewModel: OnboardingViewModel!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        
        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInformation
            .map { [unowned self] user -> Bool in
                return self.viewModel.vaildInformation(user.nickname)
            }
            .drive(onNext: { [unowned self] validation in
                if validation {
                    self.nextPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    self.nextPageButton.tintColor = .red
                } else {
                    self.nextPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    self.nextPageButton.tintColor = .systemGreen
                }
            })
            .disposed(by: rx.disposeBag)
        
        
        
    }
    
}

