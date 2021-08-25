//
//  GroceryRepository.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class GroceryRepository {
    
    let db = Database.database().reference()
    let authRepo = AuthRepository()
    

    func fetchGroceryInfo(user: User, completion: @escaping ([GroceryEntity]) -> Void) {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "ko")
            let datecompoenets = calendar.dateComponents([.year, .month], from: Date())
            let startOfMonth = calendar.date(from: datecompoenets)!
            let date = Int(startOfMonth.timeIntervalSince1970)
            
            var monthFilterQuery: DatabaseQuery?
            
        monthFilterQuery = self.db.child(user.userID).child(FBChild.groceries).queryOrdered(byChild: "date").queryStarting(atValue: date)
           
            monthFilterQuery?.observeSingleEvent(of: .value) { snapshot in
            
                let snapshot = snapshot.value as? [String:Any] ?? [:]
                
                var grocery = [GroceryEntity]()

                for value in snapshot.values {
                    let dic = value as! [String:Any]
                    let shopping = GroceryEntity(groceriesDic: dic)
                    grocery.append(shopping)
                }
                completion(grocery)
            }
    }
    
    
    func uploadGroceryInfo(grocery: GroceryShopping) {
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        let dic: [String:Any] = [
            "id" : grocery.id,
            "date" : grocery.date.dateToInt(),
            "totalPrice" : grocery.totalPrice
        ]
        
        self.db.child(currentUserUID).child(FBChild.groceries).child(grocery.id).setValue(dic)
        
    }
    
    
    func updateGroceryInfo(grocery: GroceryShopping) {
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        let dic: [String:Any] = [
            "id" : grocery.id,
            "date" : grocery.date.dateToString(),
            "totalPrice" : grocery.totalPrice
        ]
        
        self.db.child(currentUserUID).child(FBChild.groceries).child(grocery.id).updateChildValues(dic)
    }
    

    func deleteGroceryInfo(shoppingID: String) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.db.child(currentUserUID).child(FBChild.groceries).child(shoppingID).removeValue()
    }
}

