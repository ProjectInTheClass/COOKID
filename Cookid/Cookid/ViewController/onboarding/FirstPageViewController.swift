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
    
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var announceLabel: UILabel!
    @IBOutlet weak var nicknameStackView: UIStackView!
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.greetingLabel.alpha = 0
        
        self.announceLabel.alpha = 0
        self.nicknameStackView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2, delay: 1, options: .curveEaseInOut, animations: {
            self.greetingLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 2, options: .curveEaseInOut, animations: {
            self.announceLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 3, options: .curveEaseInOut, animations: {
            self.nicknameStackView.alpha = 1
        }, completion: nil)
        
        
    }
    
    func bindViewModel() {
        
        nickNameTextField.rx.text.orEmpty
            .do(onNext: { [unowned self] text in
                if viewModel.validationText(text: text) {
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
            .bind(to: viewModel.input.nickname)
            .disposed(by: rx.disposeBag)
    }
    
    
    
}

