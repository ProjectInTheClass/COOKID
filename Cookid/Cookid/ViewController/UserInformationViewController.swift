//
//  UserInformationViewController.swift
//  Cookid
//
//  Created by 김동환 on 2021/07/12.
//

import UIKit
import FirebaseDatabase

class UserInformationViewController: UIViewController {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    
    @IBOutlet weak var newDeterminationLabel: UILabel!
    @IBOutlet weak var newDeterminationTextField: UITextField!
    
    var user: User!
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.nickNameLabel.text = "\(user.nickname)님 🏳️‍🌈"
        self.budgetTextField.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
    }
    
    @IBAction func checkBtnTapped(_ sender: UIButton) {
       
        
        let newNickname = nickNameTextField.text
        
        let newGoal = budgetTextField.text
        
        let newDetermination = newDeterminationTextField.text
       
        updateUser(nickName: newNickname, newGoal: newGoal, newDetermination: newDetermination)
    }
    
    func updateUser(nickName: String?, newGoal: String?, newDetermination: String?){
        
        if let nickName = nickName {
            db.root.child(user.userID!).child("user").updateChildValues(["nickname" : nickName])
        }
        
        if let newGoal = newGoal {
            db.root.child(user.userID!).child("user").updateChildValues(["priceGoal" : newGoal])
        }
        
        if let newDetermination = newDetermination {
            db.root.child(user.userID!).child("user").updateChildValues(["determination" : newDetermination])
        }
    }
    
    @IBAction func BGTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension UserInformationViewController: UITextFieldDelegate {
    // 셋중 하나라도 텍스트가 있으면 버튼 뜨게 하기
    
}
