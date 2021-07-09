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
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var consumeView: UIView!
    @IBOutlet weak var mealCalendarView: UIView!
    @IBOutlet weak var etcView: UIView!
    @IBOutlet weak var adviseView: UIView!
    
    @IBOutlet weak var mealDayCollectionView: UICollectionView!
    
    
    // property
    
    let viewModel = MainViewModel(service: MealService())

    let mealService = MealService()
    let userService = UserService()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()

    }
    
    private func setupView() {
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
