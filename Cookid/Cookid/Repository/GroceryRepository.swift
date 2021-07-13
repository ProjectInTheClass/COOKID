//
//  GroceryRepository.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation
import FirebaseDatabase

class GroceryRepository {
    
    static let shared = GroceryRepository()
    
    let db = Database.database().reference()
    let authRepo = AuthRepository()
    
    func fetchGroceryInfo(completion: @escaping ([GroceryEntity]) -> Void) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.groceries).observeSingleEvent(of: .value) { snapshot in
            
                let snapshot = snapshot.value as! [String:Any]
                var grocery = [GroceryEntity]()

                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let decodedGrocery = try decoder.decode(GroceryEntity.self, from: data)
                    grocery.append(decodedGrocery)
                    completion(grocery)
                } catch {
                    print("Cannot fetch grocery info.. \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func uploadGroceryInfo(grocery: GroceryShopping) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            let dic: [String:Any] = [
                "id" : grocery.id,
                "date" : grocery.date.dateToString(),
                "totalPrice" : grocery.totalPrice
            ]
            self.db.child(uid).child(FBChild.groceries).setValue(dic)
        }
    }
}
