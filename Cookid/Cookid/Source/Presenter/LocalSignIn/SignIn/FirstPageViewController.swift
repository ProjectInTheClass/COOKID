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
    
    var viewModel: LocalSignInViewModel!
    
    @IBOutlet weak var cooLabel: UILabel!
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var announceLabel: UILabel!
    @IBOutlet weak var nicknameStackView: UIStackView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nextPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.alpha = 0
        cooLabel.alpha = 0
        kidLabel.transform = CGAffineTransform(rotationAngle: 1)
        kidLabel.alpha = 0
        announceLabel.alpha = 0
        nicknameStackView.alpha = 0
        nextPageButton.isEnabled = false
        view.backgroundColor = DefaultStyle.Color.bgTint
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.greetingLabel.alpha = 1
            self.kidLabel.alpha = 1
            self.cooLabel.alpha = 1
            self.kidLabel.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseInOut, animations: {
            self.announceLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 2.5, options: .curveEaseInOut, animations: {
            self.nicknameStackView.alpha = 1
        }, completion: nil)
    }
    
    func bindViewModel() {
        viewModel.output.nicknameValidation
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
                guard let isValid = isValid else { return }
                if isValid {
                    UIView.animate(withDuration: 0.5) {
                        owner.nextPageButton.setImage(UIImage(systemName: "checkmark.circle.fill")!, for: .normal)
                        owner.nextPageButton.tintColor = .systemGreen
                    }
                } else {
                    UIView.animate(withDuration: 0.5) {
                        owner.nextPageButton.setImage(UIImage(systemName: "minus.circle")!, for: .normal)
                        owner.nextPageButton.tintColor = .systemRed
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: rx.disposeBag)
    }
}
