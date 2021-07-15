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
    
    lazy var ref = db.child(authRepo.uid).child(FBChild.groceries)
    
    func fetchGroceryInfo(completion: @escaping ([GroceryEntity]) -> Void) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "ko")
            let datecompoenets = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: datecompoenets)!
            let date = Int(startOfMonth.timeIntervalSince1970)
            
            var monthFilterQuery: DatabaseQuery?
            
            monthFilterQuery = self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.groceries).queryOrdered(byChild: "date").queryStarting(atValue: date)
           
            monthFilterQuery?.observeSingleEvent(of: .value) { snapshot in
            
                let snapshot = snapshot.value as! [String:Any]
                
                var grocery = [GroceryEntity]()

                for value in snapshot.values {
                    let dic = value as! [String:Any]
                    let shopping = GroceryEntity(groceriesDic: dic)
                    grocery.append(shopping)
                }
                completion(grocery)
            }
        }
    }
    
    
    func uploadGroceryInfo(grocery: GroceryShopping) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            guard let key = self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.groceries).childByAutoId().key else { return }
            let dic: [String:Any] = [
                "id" : key,
                "date" : grocery.date.dateToInt(),
                "totalPrice" : grocery.totalPrice
            ]
            self.db.child("gYY2n6qJjNWvafCk7lFBlkExwYH2").child(FBChild.groceries).child(key).setValue(dic)
        }
    }
    
    
    func updateGroceryInfo(grocery: GroceryShopping) {
        authRepo.signInAnonymously { [weak self] uid in
            guard let self = self else { return }
            guard let key = self.db.child(uid).child(FBChild.groceries).childByAutoId().key else { return }
            let dic: [String:Any] = [
                "id" : key,
                "date" : grocery.date.dateToString(),
                "totalPrice" : grocery.totalPrice
            ]
            self.db.child(uid).child(FBChild.groceries).child(key).updateChildValues(dic)
        }
    }
    
    
    func deleteGroceryInfo() {
        
    }
}
