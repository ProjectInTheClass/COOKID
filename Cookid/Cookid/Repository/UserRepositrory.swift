//
//  UserRepositrory.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import Foundation
import FirebaseDatabase


class UserRepository {
    
    static let shared = UserRepository()
    
    let db = Database.database().reference()
    
    
    func fetchUserInfo(userID: String, completion: @escaping ([UserEntity]) -> Void) {
        db.child(FBChild.user).observeSingleEvent(of: .value) { snapshot in
            let snapshot = snapshot.value as! [String:Any]
            var users = [UserEntity]()
            
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserEntity.self, from: data)
                users.append(user)
                completion(users)
            } catch {
                print("Cannot fetch UserInfo: \(error.localizedDescription)")
            }
        }
    }
    
    
    func uploadUserInfo() {
        let dummyUser = DummyData.shared.user
        db.child(FBChild.user).setValue(dummyUser.convertToDic)
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
            }
        }
    }
    
    
}


class MealService {
    
    static let shared = MealService()
    
    func loadMeal(completion: @escaping (Meal) -> Void) {
        MealRepository.shared.fetchMeals { mealEntity in
            var meals: Meal!
            // 모델수정 요망
            // 왜 안되냐?? ㅡㅡ
            for mealEntity in mealEntity {

                let urlString = mealEntity.image!
                let url = URL(string: urlString)!

                let meal = Meal(price: mealEntity.price,
                                date: mealEntity.date.StringTodate()!,
                                name: mealEntity.name,
                                image: url,
                                mealType: MealType(rawValue: mealEntity.mealType) ?? .dineIn,
                                mealTime: MealTime(rawValue: mealEntity.mealTime) ?? .breakfast)
                meals = meal
            }
            completion(meals)
        }
    }

}

