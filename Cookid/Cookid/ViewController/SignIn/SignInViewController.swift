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
    
    var viewModel: PostViewModel!
    var localUser: LocalUser?
    lazy var authRepo = AuthRepo(userService: viewModel.userService, mealService: viewModel.mealService, shoppingService: viewModel.shoppingService)
    
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
            .bind { [unowned self] in
                print("apple login")
            }
            .disposed(by: rx.disposeBag)
        
        naverSignInButton.rx.tap
            .bind {
                print("naver login")
                self.authRepo.naverLogin { result in
                    switch result {
                    case .success(let str):
                        print("----> naverLogin success", str)
                    case .failure(let error):
                        errorAlert(selfView: self, errorMessage: error.rawValue)
                    }
                }
            }
            .disposed(by: rx.disposeBag)
        
        kakaoSignInButton.rx.tap
            .bind { [unowned self] in
                print("kakao login")
                self.authRepo.kakaoLogin { result in
                    switch result {
                    case .success(let str) :
                        print("----> kakaoLogin success", str)
                        self.authRepo.fetchKakaoUserInfo { result in
                            switch result {
                            case .success(let url):
                                let initialDineInCount = self.viewModel.mealService.initialDineInMeal
                                let initialCookidsCount = initialDineInCount + self.viewModel.shoppingService.initialShoppingCount
                                guard let localUser = self.localUser else { return }
                                self.viewModel.userService.connectUserInfo(localUser: localUser, imageURL: url, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount)
                                self.dismiss(animated: true, completion: nil)
                            case .failure(let error):
                                errorAlert(selfView: self, errorMessage: error.rawValue)
                            }
                        }
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        errorAlert(selfView: self, errorMessage: error.rawValue)
                    }
                }
            }
            .disposed(by: rx.disposeBag)
        
    }
}
