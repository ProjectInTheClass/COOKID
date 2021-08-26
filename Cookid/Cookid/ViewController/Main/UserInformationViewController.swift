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
            .drive(onNext: { [unowned self] user in
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
            .bind(to: viewModel.input.budgetText)
            .disposed(by: rx.disposeBag)
    }
    
    func setupUI(user: User) {
        self.nickNameLabel.text = "\(user.nickname)님 🏳️‍🌈"
        self.budgetLimitLabel.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
       
        viewModel.output.newUserInfo
            .take(1)
            .subscribe(on:ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .subscribe(onNext: { [unowned self] newInfo in
                
                viewModel.userService.updateUserInfo(user: newInfo) { _ in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @IBAction func BGTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
