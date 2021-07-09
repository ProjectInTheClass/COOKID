//
//  MainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MainViewController: UIViewController {

    // outlet
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var consumeView: UIView!
    @IBOutlet weak var mealCalendarView: UIView!
    @IBOutlet weak var etcView: UIView!
    @IBOutlet weak var adviseView: UIView!
    
    @IBOutlet weak var mealDayCollectionView: UICollectionView!
    
    
    // property
    
    let viewModel = MainViewModel(service: Service())

    let mealService = MealService()
    let userService = UserService()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
      
//        MealRepository.shared.fetchMeals { meals in
//            print(meals)
//        }
//
//        mealService.fetchGroceries { gro in
//            print(gro)
//        }
        
        GroceryRepository.shared.fetchGroceryInfo { gro in
            
            gro[0].groceries[0].name
            
        }
////
//        userService.fetchUserInfo(userID: nil) { entity in
//            print(entity)
//        }

//        mealService.fetchMeals { meals in
//            print(meals.first?.name)
//        }
        
//        UserService.shared.loadUserInfo(userID: UserRepository.shared.uid) { user in
//            print(user)
//        }
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
    
    private func setupView() {
        addView.makeShadow()
        chartView.makeShadow()
        mealCalendarView.makeShadow()
        consumeView.makeShadow()
        etcView.makeShadow()
        adviseView.makeShadow()
    }
    
    private func bindViewModel() {
        
        viewModel.output.mealDayList
            .drive(mealDayCollectionView.rx.items(cellIdentifier: "mainMealCell", cellType: MealDayCollectionViewCell.self)) { item, meal, cell in
                cell.updateUI(meal: meal)
            }
            .disposed(by: rx.disposeBag)
        
        mealDayCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
