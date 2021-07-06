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
    
    
    func fetchGroceryInfo(completion: @escaping ([GroceryEntity]) -> Void) {
        db.child(FBChild.groceries).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var groceries = [GroceryEntity]()
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let grocery = try decoder.decode(GroceryEntity.self, from: data)
                groceries.append(grocery)
                completion(groceries)
            } catch {
                print("Cannot fetch grocery info.. \(error.localizedDescription)")
            }
        }
    }
    
    
//    func uploadGroceryInfo() {
//        let dummyGroceries = DummyData.shared.mySingleShopping
//        db.child(FBChild.groceries).setValue(dummyGroceries.converToDic)
//    }
}
