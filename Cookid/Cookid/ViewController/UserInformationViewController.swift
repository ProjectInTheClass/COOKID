//
//  UserInformationViewController.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/12.
//

import UIKit
import RxCocoa
import RxSwift

class UserInformationViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    
    @IBOutlet weak var newDeterminationLabel: UILabel!
    @IBOutlet weak var newDeterminationTextField: UITextField!
    
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var user: User?
    
    func bindViewModel() {
        
        viewModel.output.userInfo
            .drive(onNext: { [unowned self] user in
                self.user = user
                setupUI(user: user)
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    func setupUI(user: User){
        self.nickNameLabel.text = "\(user.nickname)님 🏳️‍🌈"
        self.budgetLimitLabel.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        guard let user = user else { return }
        
        var newNickname: String {
            return self.nickNameTextField.text!.isEmpty ? user.nickname : self.nickNameTextField.text!
        }
        
        var newGoal: String {
            return self.budgetTextField.text!.isEmpty ? user.priceGoal : self.budgetTextField.text!
        }
        
        var newDetermination: String {
            return self.newDeterminationTextField.text!.isEmpty ? user.determination : self.newDeterminationTextField.text!
        }
        
        let newUser = User(userID: user.userID, nickname: newNickname, determination: newDetermination, priceGoal: newGoal, userType: user.userType)
        
        viewModel.userService.updateUserInfo(user: newUser)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BGTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
