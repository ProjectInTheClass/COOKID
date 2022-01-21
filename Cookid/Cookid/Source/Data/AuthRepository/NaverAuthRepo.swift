//
//  NaverAuthRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/01.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class NaverAutoRepo {
    static let shared = NaverAutoRepo()
    
    var viewModel: PostViewModel!
    
    private let connectionInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    var isSignIn: Bool {
        return connectionInstance?.accessToken != nil
    }
    
    func setDelegate(newValue: NaverThirdPartyLoginConnectionDelegate?) {
        connectionInstance?.delegate = newValue
    }
    
    func naverLogin() {
        connectionInstance?.requestThirdPartyLogin()
    }
    
    func naverLogout() {
        connectionInstance?.requestDeleteToken()
    }
    
    func fetchNaverUserInfo(completion: @escaping (Bool) -> Void) {
        
        guard let isValidAccessToken = connectionInstance?.isValidAccessTokenExpireTimeNow() else { return }
        guard isValidAccessToken else { return }
        
        guard let tokenType = connectionInstance?.tokenType else { return }
        guard let accessToken = connectionInstance?.accessToken else { return }
        
        let urlString = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlString)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            
            switch response.result {
            case .success(let object as [String:Any]):
                guard let localUser = self.viewModel.userService.fetchLocalUser() else { return }
                let initialDineInCount = self.viewModel.mealService.initialDineInMeal
                let initialCookidsCount = initialDineInCount + self.viewModel.shoppingService.initialShoppingCount
                guard let newResponse = object["response"] as? [String:Any] else { return }
                if let imageURLString = newResponse["profile_image"] as? String {
                    let imageURL = URL(string: imageURLString)!
                    self.viewModel.userService.connectUser(localUser: localUser, imageURL: imageURL, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount) { success in
                        if success {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    let image = UIImage(systemName: "person.circle.fill")
                    self.viewModel.userService.uploadUserImage(userID: localUser.id.stringValue, image: image) { result in
                        switch result {
                        case .success(let imageURL):
                            self.viewModel.userService.connectUser(localUser: localUser, imageURL: imageURL, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount) { success in
                                if success {
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            }
                        case .failure(let error):
                            print("upload image error \(error)")
                            completion(false)
                        }
                    }
                }
            case .failure(let error):
                print("naver User fetch error \(error)")
                completion(false)
            default:
                completion(false)
            }
        }
    }
}
