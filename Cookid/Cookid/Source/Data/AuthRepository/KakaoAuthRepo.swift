//
//  KakaoAuthRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/02.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthRepo {
    static let shared = KakaoAuthRepo()
    
    var viewModel: PostViewModel!
    
    func isSignIn(completion: @escaping (Bool) -> Void) {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        print("sdkError \(error)")
                        completion(false)
                    } else {
                        print("etcError \(error)")
                        completion(false)
                    }
                } else {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func kakaoLogin(completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(_, error) in
                if let error = error {
                    print("Kakao Login Error \(error)")
                    completion(.failure(.signInError))
                } else {
                    print("loginWithKakaoTalk() success.")
                    completion(.success(.successSignIn))
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(_, error) in
                if let error = error {
                    print("Kakao Login Error \(error)")
                    completion(.failure(.signInError))
                } else {
                    print("loginWithKakaoAccount() success.")
                    print("loginWithKakaoTalk() success.")
                    completion(.success(.successSignIn))
                }
            }
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
    
    func fetchKakaoUserInfo(completion: @escaping (Result<NetWorkingResult, NetWorkingError>) -> Void) {
        UserApi.shared.me { user, error in
            if let error = error {
                print("fetch user error \(error)")
                completion(.failure(.fetchError))
            } else {
                guard let localUser = self.viewModel.userService.fetchLocalUser() else { return }
                let initialDineInCount = self.viewModel.mealService.initialDineInMeal
                let initialCookidsCount = initialDineInCount + self.viewModel.shoppingService.initialShoppingCount
                let url = user?.kakaoAccount?.profile?.profileImageUrl
                self.viewModel.userService.connectUser(localUser: localUser, imageURL: url, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount) { success in
                    if success {
                        completion(.success(.successSignIn))
                    } else {
                        completion(.failure(.signInError))
                    }
                }
                
            }
        }
    }
}
