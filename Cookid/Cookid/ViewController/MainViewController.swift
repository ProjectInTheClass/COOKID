//
//  MainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class MainViewController: UIViewController {

    let mealService = MealService()
    let userService = UserRepository()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mealService.fetchGroceries {
            
        }
        
        userService.fetchUserInfo(userID: nil) { entity in
            print(entity)
        }
        
    }
    


}
