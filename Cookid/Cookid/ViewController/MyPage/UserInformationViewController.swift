//
//  UserInformationViewController.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/12.
//

import UIKit
import RxCocoa
import RxSwift
import RxKeyboard

class UserInformationViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var newDeterminationLabel: UILabel!
    @IBOutlet weak var newDeterminationTextField: UITextField!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var completeButton: UIButton!
    
    var viewModel: UserInfoUpdateViewModel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
    
    func setUI() {
        self.userInputView.layer.cornerRadius = 8
    }
   
    func bindViewModel() {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                if keyboardVisibleHeight != 0 {
                    self.inputViewBottom.constant = keyboardVisibleHeight
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInfo
            .bind(onNext: { [unowned self] user in
                self.user = user
                setupUI(user: user)
            })
            .disposed(by: rx.disposeBag)
        
        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nickNameText)
            .disposed(by: rx.disposeBag)
        
        newDeterminationTextField.rx.text.orEmpty
            .bind(to: viewModel.input.determinationText)
            .disposed(by: rx.disposeBag)
        
        budgetTextField.rx.text.orEmpty
            .bind(onNext: { [unowned self] text in
                let value = Int(text) ?? 0
                self.viewModel.input.budgetText.onNext(value)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.newUserInfo
            .bind { [unowned self] user in
                self.user = user
            }
            .disposed(by: rx.disposeBag)
        
        completeButton.rx.tap
            .bind { [unowned self] in
//                guard let newUserInfo = self.user else { return }
//                self.viewModel.userService.updateUserInfo(user: newUserInfo) { _ in
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
                AuthRepo.instance.kakaoLogout()
            }
            .disposed(by: rx.disposeBag)
    }
    
    func setupUI(user: User) {
        self.nickNameLabel.text = "\(user.nickname)님 🏳️‍🌈"
        self.budgetLimitLabel.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
    }
    
    @IBAction func BGTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
