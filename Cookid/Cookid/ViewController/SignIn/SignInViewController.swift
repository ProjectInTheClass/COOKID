//
//  SignInViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - UI Components
    
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var naverSignInButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: OnboardingViewModel!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kidLabel.text = "😀"
        UIView.animate(withDuration: 0.3, delay: 1) { [unowned self] in
            self.kidLabel.text = "KID"
        }
    }
    
    // MARK: - bindViewModel
    
    func bindViewModel() {
        
        appleSignInButton.rx.tap
            .bind {
                print("apple login")
            }
            .disposed(by: rx.disposeBag)
        
        naverSignInButton.rx.tap
            .bind {
                print("naver login")
            }
            .disposed(by: rx.disposeBag)
        
        kakaoSignInButton.rx.tap
            .bind {
                print("kakao login")
            }
            .disposed(by: rx.disposeBag)
        
    }
}
