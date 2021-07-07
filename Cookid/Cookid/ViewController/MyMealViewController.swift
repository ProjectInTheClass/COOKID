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
    
    
    let viewModel = MyMealViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progresstimer()
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
        
        viewModel.output.mostExpensiveMeal
            .drive(onNext: { [unowned self] meal in
                self.mealName.text = meal.name
                self.mealPrice.text = "\(meal.price)"
                self.mealType.text = meal.mealType.rawValue
                self.mealImage.image = UIImage(systemName: meal.image)!
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.recentMeals
            .drive(mealTableView.rx.items(cellIdentifier: "mealCell", cellType: MealTableViewCell.self)) { row, meal, cell in
                cell.mealCellImage.image = UIImage(systemName: meal.image)!
                cell.mealCellName.text = meal.name
                cell.mealCellPrice.text = "\(meal.price)"
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealtimes
            .drive(mealTimeCollectionView.rx.items(cellIdentifier: "timeCell")) { item, num, cell in
                cell.backgroundColor = .blue
            }
            .disposed(by: rx.disposeBag)
        
        mealTimeCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)

    }
    
    private func progresstimer() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.dineInProgressBar.progress = self.viewModel.output.dineInProgressCalc(meals: DummyData.shared.myMeals)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6, height: collectionView.frame.height)
    }
    
}
