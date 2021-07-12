//
//  MyMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa

class MyMealViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
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
    
    let viewModel = MyMealViewModel(mealService: MealService())
    var maxValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dineInProgressBar.progress = 0
    }
    
    private func configureUI() {
        dineStaticView.makeShadow()
        mostExpensiveStaticView.makeShadow()
        latestMealStaticView.makeShadow()
        dineInCircleView.makeCircleView()
        dineOutCircleView.makeCircleView()
    }
    
    func bindViewModel() {
        
        viewModel.output.dineInProgress
            .delay(.microseconds(500))
            .drive(onNext: { progress in
                self.dineInProgressBar.progress = progress
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mostExpensiveMeal
            .drive(onNext: { [unowned self] meal in
                self.mealName.text = meal.name
                self.mealPrice.text = "\(meal.price)"
                self.mealType.text = meal.mealType.rawValue
                self.mealImage.kf.setImage(with: meal.image, placeholder: UIImage(systemName: "person.circle.fill"))
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.recentMeals
            .drive(mealTableView.rx.items(cellIdentifier: "mealCell", cellType: MealTableViewCell.self)) { row, meal, cell in
                cell.mealCellImage.kf.setImage(with: meal.image, placeholder: UIImage(systemName: "person.circle.fill"))
                cell.mealCellName.text = meal.name
                cell.mealCellPrice.text = "\(meal.price)"
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealtimes
            .do(onNext: { [weak self] mealses in
                let numArr = mealses.map { $0.count }
                self?.maxValue = numArr.max()
            })
            .drive(mealTimeCollectionView.rx.items(cellIdentifier: "timeCell", cellType: MealTimeCollectionViewCell.self)) { item, meals, cell in
                if let maxValue = self.maxValue {
                    let ratio = CGFloat(meals.count) / CGFloat(maxValue)
                    let arrString = meals.first?.mealTime.rawValue ?? ""
                    cell.updateUI(ratio: ratio, name: arrString)
                }
                cell.backgroundColor = .white
            }
            .disposed(by: rx.disposeBag)
        
        mealTimeCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6 - 5, height: collectionView.frame.height)
    }
    
}
