//
//  UserInformationViewController.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/12.
//

import UIKit


class UserInformationViewController: UIViewController {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    
    @IBOutlet weak var newDeterminationLabel: UILabel!
    @IBOutlet weak var newDeterminationTextField: UITextField!
    
    var user: User!
    
    let viewModel = UserInfoUpdateViewModel(userService: UserService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.nickNameLabel.text = "\(user.nickname)님 🏳️‍🌈"
        self.budgetTextField.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
        
        var newNickname: String {

            if let text = self.nickNameTextField.text{
                return text.isEmpty ? self.user.nickname : text
            }

        var newGoal: String {
            return self.budgetTextField.text!.isEmpty ? self.user.nickname : self.budgetTextField.text!
        }
        
        var newDetermination: String {
            return self.newDeterminationTextField.text!.isEmpty ? self.user.nickname : self.newDeterminationTextField.text!
        }
        
        let user = User(userID: self.user.userID, nickname: newNickname, determination: newDetermination, priceGoal: newGoal, userType: self.user.userType)
        
        updateUser(user: user)
    }
    
    func updateUser(user: User){
        
        self.viewModel.updateUser(user: user)
    }
    
    @IBAction func BGTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension UserInformationViewController: UITextFieldDelegate {
    // 셋중 하나라도 텍스트가 있으면 버튼 뜨게 하기
    
}
