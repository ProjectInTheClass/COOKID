//
//  AuthRepository.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/08.
//

import Foundation
import FirebaseAuth

class AuthRepository {
    static let shared = AuthRepository()
    
    func signInAnonymously(completion: @escaping (String) -> Void) {
        Auth.auth().signInAnonymously { authdata, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let user = authdata?.user else { return }
                completion(user.uid)
            }
        }
    }
    
    var isLogined: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func userLogout(completion: @escaping (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch let err {
            print(err)
            completion(false)
        }
        
    }
}
