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

class AuthRepo: HasDisposeBag {
    static let instance = AuthRepo()
    
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
                .subscribe(onNext: { oauthToken in
                    print("loginWithKakaoTalk() success.")
                    completion(.success(.successSignIn))
                }, onError: { error in
                    print(error)
                    completion(.failure(.signInError))
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { oauthToken in
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
    
}
