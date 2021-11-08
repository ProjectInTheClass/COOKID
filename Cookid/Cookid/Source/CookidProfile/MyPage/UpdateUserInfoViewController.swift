//
//  UpdateUserInfoViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import RxCocoa
import RxSwift
import RxKeyboard
import NSObject_Rx
import Then
import SnapKit

class UpdateUserInfoViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var budgetLimitLabel: UILabel!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var newDeterminationLabel: UILabel!
    @IBOutlet weak var newDeterminationTextField: UITextField!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var dimmingButton: UIButton!
    @IBOutlet weak var userInputViewCenterY: NSLayoutConstraint!
    
    private let activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    var viewModel: MyPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let inputViewMaxY = userInputView.frame.maxY
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let visualHeight = view.frame.size.height - height
                if inputViewMaxY > visualHeight {
                    let updateHeight = inputViewMaxY - visualHeight
                    self.userInputViewCenterY.constant = -updateHeight - 10
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func configureUI() {
        self.userInputView.layer.cornerRadius = 8
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
   
    func bindViewModel() {
        
        dimmingButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInfo
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.setupUI(user: user)
            })
            .disposed(by: rx.disposeBag)
        
        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.userNickname)
            .disposed(by: rx.disposeBag)
        
        newDeterminationTextField.rx.text.orEmpty
            .bind(to: viewModel.input.userDetermination)
            .disposed(by: rx.disposeBag)
        
        budgetTextField.rx.text.orEmpty
            .bind(to: viewModel.input.userBudget)
            .disposed(by: rx.disposeBag)
        
        completeButton.rx.tap
            .do(onNext: { [unowned self] in
                self.activityIndicator.startAnimating()
            })
            .bind(to: viewModel.input.updateButtonTapped)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.completionUpdate
            .withUnretained(self)
            .bind(onNext: { owner, value in
                if value {
                    owner.activityIndicator.stopAnimating()
                    owner.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func setupUI(user: User) {
        titleLabel.text = "HI! \(user.nickname)님 🏳️‍🌈"
        nickNameLabel.text = "현재 닉네임은 '\(user.nickname)' 입니다 🍣"
        budgetLimitLabel.text = "현재 목표액은 \(user.priceGoal)원 입니다 💵"
        nickNameTextField.rx.text.onNext(user.nickname)
        newDeterminationTextField.rx.text.onNext(user.determination)
        budgetTextField.rx.text.onNext("\(user.priceGoal)")
    }

}
