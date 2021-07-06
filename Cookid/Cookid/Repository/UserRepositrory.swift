//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import FirebaseDatabase


class UserRepository {
    
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    
    func fetchUserInfo(userID: String?, completion: @escaping ([UserEntity]) -> Void) {
        
        let key = db.child(FBChild.user).childByAutoId().key
        
        db.child(FBChild.user).child(key!).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var users = [UserEntity]()
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserEntity.self, from: data)
                users.append(user)
                print(users)
                completion(users)
            } catch {
                print("Cannot fetch UserInfo: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadUserInfo() {
        let dummyUser = DummyData.shared.singleUser
        db.child(FBChild.user).childByAutoId().setValue(dummyUser.converToDic)
    }
}




class UserService {
    
    func loadUserInfo(userID: String, completion: @escaping (User) -> Void) {
        UserRepository.shared.fetchUserInfo(userID: userID) { userEntity in
            var users: User!
            
            for userEntity in userEntity {
                let userinfo = User(
                    nickname: userEntity.nickname,
                    determination: userEntity.determination,
                    priceGoal: userEntity.priceGoal,
                    userType: UserType(rawValue: userEntity.userType)!)
                users = userinfo
            }
            completion(users)
        }
    }
}


class MealService {
    
    static let shared = MealService()
    
    func loadMeal(completion: @escaping (Meal) -> Void) {
        MealRepository.shared.fetchMeals { mealEntity in
            var meals: Meal!
            
            for mealEntity in mealEntity {

                let meal = Meal(price: mealEntity.price,
                                date: mealEntity.date.StringTodate()!,
                                name: mealEntity.name,
                                image: UIImage(systemName: "box")!,
                                mealType: MealType(rawValue: mealEntity.mealType)!,
                                mealTime: MealTime(rawValue: mealEntity.mealTime)!)
                meals = meal
            }
            completion(meals)
        }
    }
}

