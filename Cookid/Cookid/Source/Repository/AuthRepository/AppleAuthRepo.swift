//
//  AppleAuthRepo.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/01.
//

import UIKit
import AuthenticationServices

class AppleAuthRepo {
    static let shared = AppleAuthRepo()
    
    var viewModel: PostViewModel!
    let keyChainAuthRepo = KeyChainAuthRepo.shared
    
    private var appleIDProvider: ASAuthorizationAppleIDProvider {
        return ASAuthorizationAppleIDProvider()
    }
    
    var appleAuthController: ASAuthorizationController {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []
        return ASAuthorizationController(authorizationRequests: [request])
    }
    
    func isSignIn(completion: @escaping (Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        guard let userIdentifier = keyChainAuthRepo.read(account: "userIdentifier") else { return completion(false) }
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, _ in
            switch credentialState {
            case .authorized:
                completion(true)
            case .revoked:
                completion(false)
            case .notFound:
                completion(false)
            default:
                completion(false)
            }
        }
    }
    
    func appleLogout() {
        keyChainAuthRepo.delete(account: "userIdentifier")
    }
    
    func fetchAppleUserInfo(completion: @escaping (Bool) -> Void) {
        guard let localUser = RealmUserRepo.instance.fetchUser() else { return }
        let initialDineInCount = self.viewModel.mealService.initialDineInMeal
        let initialCookidsCount = initialDineInCount + self.viewModel.shoppingService.initialShoppingCount
        let image = UIImage(systemName: "person.circle.fill")
        FirebaseStorageRepo.instance.uploadUserImage(userID: localUser.id.stringValue, image: image) { imageURL in
            self.viewModel.userService.connectUserInfo(localUser: localUser, imageURL: imageURL, dineInCount: initialDineInCount, cookidsCount: initialCookidsCount) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
}
