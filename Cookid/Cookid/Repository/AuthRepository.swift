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
    
    var uid: String = ""
    var isAnonymous: Bool = false

    init() {
        signInAnonymously { uid in
            self.uid = uid
        }
    }
    
    func signInAnonymously(completion: @escaping (String) -> Void) {
        
        Auth.auth().signInAnonymously { [weak self] authdata, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let user = authdata?.user else { return }
                self.uid = user.uid
                self.isAnonymous = user.isAnonymous
                if user.isAnonymous {
                    self.uid = Auth.auth().currentUser!.uid
                }
                completion(self.uid)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
        
    }
    
    var isLogined: Bool {
        return Auth.auth().currentUser != nil
    }
}
