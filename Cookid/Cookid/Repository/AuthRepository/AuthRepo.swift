//
//  AuthRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import NSObject_Rx
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import NaverThirdPartyLogin
import Alamofire

class AuthRepo: NSObject, HasDisposeBag, NaverThirdPartyLoginConnectionDelegate {
    
    let userService: UserService
    let mealService: MealService
    let shoppingService: ShoppingService
    
    init(userService: UserService, mealService: MealService, shoppingService: ShoppingService) {
        self.userService = userService
        self.mealService = mealService
        self.shoppingService = shoppingService
    }
    
    func isSignIn(completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        if AuthApi.hasToken() {
            UserApi.shared.rx.accessTokenInfo()
                .subscribe(onSuccess: { _ in
                    completion(.success(.successSignIn))
                }, onError: { error in
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        // 로그인 필요
                        completion(.failure(.signInError))
                    } else {
                        // 기타 에러
                        completion(.failure(.networkError))
                    }
                })
                .disposed(by: disposeBag)
        } else {
            // 로그인 필요
            completion(.failure(.signInError))
        }
    }
    
    func kakaoLogin(completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: { _ in
                    print("loginWithKakaoTalk() success.")
                    completion(.success(.successSignIn))
                }, onError: { error in
                    print(error)
                    completion(.failure(.signInError))
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { _ in
                    print("loginWithKakaoAccount() success.")
                    completion(.success(.successSignIn))
                }, onError: {error in
                    print(error)
                    completion(.failure(.signInError))
                })
                .disposed(by: disposeBag)
        }
    }
    
    func fetchKakaoUserInfo(completion: @escaping (Result<URL?, NetWorkingError>) -> Void) {
        
        UserApi.shared.rx.scopes()
            .subscribe(onSuccess: { scopeInfo in
                print(scopeInfo)
            }, onError: { error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { user in
                print("me() success.")
                completion(.success(user.kakaoAccount?.profile?.profileImageUrl))
            }, onError: {error in
                print(error)
                completion(.failure(.fetchError))
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoLogout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: {
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func naverLogin(completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    func fetchNaverUserInfo() {

        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        guard isValidAccessToken else { return }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlString = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlString)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { [weak self] response in
            guard let self = self else { return }
            guard let result = response.value as? [String:Any] else { return }
            guard let object = result["response"] as? [String:Any] else { return }
            
            guard let localUser = RealmUserRepo.instance.fetchUser() else { return }
            let initialDineInCount = self.mealService.initialDineInMeal
            let initialCookidsCount = initialDineInCount + self.shoppingService.initialShoppingCount
            
            if let imageURL = object["imageURL"] as? URL {
                self.userService.connectUserInfo(localUser: localUser, imageURL: imageURL, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount)
            } else {
                let image = UIImage(systemName: "person.circle.fill")
                FirebaseStorageRepo.instance.uploadUserImage(userID: localUser.id.stringValue, image: image) { imageURL in
                    self.userService.connectUserInfo(localUser: localUser, imageURL: imageURL, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount)
                }
            }
        }
    }
    
    func naverLogout() {
        loginInstance?.requestDeleteToken()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("naver Login Success")
        fetchNaverUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() { }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("naver login Error : \(String(describing: error))")
    }
}
