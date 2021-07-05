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

class FirstPageViewController: UIViewController, ViewModelBindable {
   
    var viewModel: OnboardingViewModel!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    
    var completionHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    func bindViewModel() {
        nextPageButton.isHidden = true
        
        nickNameTextField.rx.text.orEmpty
            .do(onNext: { [weak self] text in
                if let text = self?.nickNameTextField.text,
                   !text.isEmpty {
                    self?.nextPageButton.isHidden = false
                } else {
                    self?.nextPageButton.isHidden = true
                }
            })
            .bind(to: viewModel.input.nickname)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInformation
            .subscribe(onNext: { [weak self] user in
                self?.nicknameLabel.text = user.nickname
            })
            .disposed(by: rx.disposeBag)
    }
 
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if let completionHandler = completionHandler {
            completionHandler()
        }
    }
    
    
    
}

