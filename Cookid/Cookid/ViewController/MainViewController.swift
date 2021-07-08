//
//  MainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class MainViewController: UIViewController {

    let mealService = MealService()
    let userService = UserService()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        mealService.fetchGroceries {
//
//        }
//
//        userService.fetchUserInfo(userID: nil) { entity in
//            print(entity)
//        }

//        mealService.fetchMeals { meals in
//            print(meals.first?.name)
//        }
        
        UserService.shared.loadUserInfo(userID: UserRepository.shared.uid) { user in
            print(user)
        }
//        
//        UserRepository.shared.fetchUserInfo{ userEntity in
//            print(userEntity)
//        }
        
//        UserRepository.shared.uploadUserInfo(userInfo: DummyData.shared.singleUser)
//
//        MealRepository.shared.signInAnonymously()
//
//        MealRepository.shared.pushToFirebase(meal: DummyData.shared.mySingleMeal)
        
    }
    


}
