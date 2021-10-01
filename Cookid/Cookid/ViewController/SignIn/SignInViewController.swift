//
//  SignInViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/05.
//

import UIKit
import RxSwift
import RxCocoa
import NaverThirdPartyLogin
import Alamofire

class SignInViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - UI Components
    
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var naverSignInButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: PostViewModel!
    var localUser: LocalUser?
    let naverAuthRepo = NaverAutoRepo.shared
    lazy var authRepo = AuthRepo(viewModel: viewModel)
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naverAuthRepo.viewModel = viewModel
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
                print("appleLogin")
                self.naverAuthRepo.naverLogout()
            }
            .disposed(by: rx.disposeBag)
        
        naverSignInButton.rx.tap
            .bind { [unowned self] in
                print("naver login")
                self.naverAuthRepo.setDelegate(newValue: self)
                self.naverAuthRepo.naverLogin()
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
                                self.viewModel.userService.connectUserInfo(localUser: localUser, imageURL: url, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount, completion: { success in
                                    if success {
                                        self.dismiss(animated: true, completion: nil)
                                    } else {
                                        errorAlert(selfView: self, errorMessage: "사용자 연결에 실패했습니다.")
                                    }
                                })
                                
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

extension SignInViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("naver Login Success")
        naverAuthRepo.fetchNaverUserInfo(viewController: self)
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("naver Refresh Token Success")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("naver Logout Success")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("naver login Error : \(String(describing: error))")
    }
}
