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
import AuthenticationServices

class SignInViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - UI Components
    
    @IBOutlet weak var kidLabel: UILabel!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var naverSignInButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!

    // MARK: - Properties
    
    var viewModel: PostViewModel!
    var localUser: LocalUser?
    lazy var naverAuthRepo = NaverAutoRepo.shared
    lazy var kakaoAuthRepo = KakaoAuthRepo.shared
    lazy var appleAuthRepo = AppleAuthRepo.shared
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    // MARK: - bindViewModel
    
    func bindViewModel() {
        
        appleSignInButton.rx.tap
            .bind { [unowned self] in
                appleLogin()
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
                self.kakaoAuthRepo.kakaoLogin { result in
                    switch result {
                    case .success(let str) :
                        print("----> kakaoLogin success", str)
                        self.kakaoAuthRepo.fetchKakaoUserInfo { result in
                            switch result {
                            case .success(let success):
                                print(success.rawValue)
                                self.dismiss(animated: true, completion: nil)
                            case .failure(let error):
                                print(error.rawValue)
                            }
                        }
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
        naverAuthRepo.fetchNaverUserInfo { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                errorAlert(selfView: self, errorMessage: "사용자 정보를 가져오지 못했습니다.")
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("naver Refresh Token Success")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("naver Logout Success")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("naver login Error : \(String(describing: error))")
        errorAlert(selfView: self, errorMessage: "네이버 로그인에 실패했습니다ㅠㅠ")
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = []
        let appleAuthController = ASAuthorizationController(authorizationRequests: [request])
        appleAuthController.presentationContextProvider = self
        appleAuthController.delegate = self
        appleAuthController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("----------> success")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            appleAuthRepo.fetchAppleUserInfo { success in
                if success {
                    let userIdentifier = appleIDCredential.user
                    KeyChainAuthRepo.shared.create(account: "userIdentifier", value: userIdentifier)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            errorAlert(selfView: self, errorMessage: "사용자 정보를 가져오지 못했습니다.")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        errorAlert(selfView: self, errorMessage: "애플 로그인에 실패했습니다ㅠㅠ")
    }
    
}
