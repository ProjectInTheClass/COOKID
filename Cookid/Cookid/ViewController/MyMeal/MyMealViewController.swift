//
//  MyMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa

class MyMealViewController: UIViewController, UICollectionViewDelegateFlowLayout, ViewModelBindable, StoryboardBased {
    
    @IBOutlet weak var dineStaticView: UIView!
    @IBOutlet weak var mostExpensiveStaticView: UIView!
    @IBOutlet weak var latestMealStaticView: UIView!
    
    @IBOutlet weak var dineInCircleView: UIView!
    @IBOutlet weak var dineOutCircleView: UIView!
    
    @IBOutlet weak var dineInProgressBar: PlainHorizontalProgressBar!
    
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealType: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealTableView: UITableView!
    @IBOutlet weak var mealTimeCollectionView: UICollectionView!
    
    var viewModel : MyMealViewModel!

    var maxValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        dineStaticView.makeShadow()
        mostExpensiveStaticView.makeShadow()
        latestMealStaticView.makeShadow()
        dineInCircleView.makeCircleView()
        dineOutCircleView.makeCircleView()
        mealImage.makeCircleView()
        configureNavTab()
    }
    
    private func configureNavTab() {
        self.navigationItem.title = "식사 통계 🥗"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.tabBarItem.image = UIImage(systemName: "chart.pie")
        self.tabBarItem.selectedImage = UIImage(systemName: "chart.pie.fill")
        self.tabBarItem.title = "식사 관리"
    }
    
    func bindViewModel() {

        viewModel.output.dineInProgress
            .delay(.microseconds(500))
            .drive(onNext: { [unowned self] progress in
                self.dineInProgressBar.progress = progress
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mostExpensiveMeal
            .drive(onNext: { [unowned self] meal in
                self.mealName.text = meal.name
                self.mealPrice.text = intToString(meal.price)
                self.mealType.text = meal.mealType.rawValue
                self.mealImage.image = meal.image ?? UIImage(systemName: "circle.fill")
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.recentMeals
            .drive(mealTableView.rx.items(cellIdentifier: "mealCell", cellType: MealTableViewCell.self)) { _, meal, cell in
                cell.mealCellImage.image = meal.image ?? UIImage(systemName: "circle.fill")
                cell.mealCellName.text = meal.name
                cell.mealCellPrice.text = intToString(meal.price)
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealtimes
            .do(onNext: { [weak self] mealses in
                let numArr = mealses.map { $0.count }
                self?.maxValue = numArr.max()
            })
            .drive(mealTimeCollectionView.rx.items(cellIdentifier: "timeCell", cellType: MealTimeCollectionViewCell.self)) { _, meals, cell in
                if let maxValue = self.maxValue,
                   maxValue != 0 {
                    let ratio = CGFloat(meals.count) / CGFloat(maxValue)
                    let arrString = meals.first?.mealTime.rawValue ?? ""
                    cell.updateUI(ratio: ratio, name: arrString)
                    cell.backgroundColor = .white
                } else {
                    let arrString = meals.first?.mealTime.rawValue ?? ""
                    cell.updateUI(ratio: 0.5, name: arrString)
                    cell.backgroundColor = .white
                }
            }
            .disposed(by: rx.disposeBag)
        
        mealTimeCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6 - 5, height: collectionView.frame.height)
    }
    
}
