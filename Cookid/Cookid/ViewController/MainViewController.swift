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
//
//        mealService.fetchMeals { meals in
//            print(meals.first?.name)
//        }
        UserRepository.shared.signInAnonymously { uid in
            GroceryRepository.shared.fetchGroceryInfo(uid: uid) { entity in
                print(entity)
            }
        }
        
        
    }
    


}
