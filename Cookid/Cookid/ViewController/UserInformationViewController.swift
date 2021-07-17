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
    
    @IBOutlet weak var userInputView: UIView!
    
    var viewModel: MainViewModel!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addNotiObserver()
        setTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: false, completion: nil)
    }
    
    func setUI(){
        self.userInputView.layer.cornerRadius = 8
    }
    
    func setTapGesture(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        tap.delegate = self
        self.userInputView.addGestureRecognizer(tap)
    }
    
    func addNotiObserver(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleShow(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide(keyboardShowNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func handleShow(keyboardShowNotification notification: Notification) {
        
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.userInputView.frame.midY == self.view.frame.midY {
                self.userInputView.frame.origin.y -= (keyboardRectangle.height / 2)
            }
        }
    }
    
    @objc
    private func handleHide(keyboardShowNotification notification: Notification) {
        
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.userInputView.frame.midY != self.view.frame.midY {
                self.userInputView.frame.origin.y += (keyboardRectangle.height / 2)
            }
        }
    }
    
    @objc func dismisskeyboard(){
        budgetTextField.resignFirstResponder()
        nickNameTextField.resignFirstResponder()
        newDeterminationTextField.resignFirstResponder()
    }
    
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

extension UserInformationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: nickNameTextField) == true) {
            return false
        } else if(touch.view?.isDescendant(of: budgetTextField) == true) {
            return false
        } else if (touch.view?.isDescendant(of: newDeterminationTextField) == true) {
            return false
        } else {
            userInputView.endEditing(true)
            return true
        }
    }
}
