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
    
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.annotationLabel.text = "사용자님의"
    }
    
    func bindViewModel() {
        
        nickNameTextField.rx.text.orEmpty
            .do(onNext: { [unowned self] text in
                if self.validationText(text: text) {
                    self.annotationLabel.text = "닉네임은"
                    self.annotationLabel.tintColor = .black
                    self.nextPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                    self.nextPageButton.tintColor = .systemGreen
                } else {
                    self.annotationLabel.text = "좀 더 긴 닉네임이 있을까요?"
                    self.annotationLabel.tintColor = .red
                    self.nextPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                    self.nextPageButton.tintColor = .red
                }
            })
            .bind(to: viewModel.input.nickname)
            .disposed(by: rx.disposeBag)
    }
    
    func validationText(text: String) -> Bool {
        return text.count > 3
    }
    
}

