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
        nextPageButton.isHidden = true
    }
    
    func bindViewModel() {
        
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
        
    }
    
}

