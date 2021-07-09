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
 
    // userview
    @IBOutlet weak var etcView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userDetermination: UILabel!
    
    // buttonView
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet weak var addShoppingButton: UIButton!
    
    // consumeView
    @IBOutlet weak var consumeView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceGoalLabel: UILabel!
    @IBOutlet weak var shoppingPrice: UILabel!
    @IBOutlet weak var dineOutPrice: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    //adviseView
    @IBOutlet weak var adviseView: UIView!
    @IBOutlet weak var adviseLabel: UILabel!
    
    // chartView
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var chartPercentLabel: UILabel!
    
    // mealCalendarView
    @IBOutlet weak var mealCalendarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var monthSelectButton: UIButton!
    @IBOutlet weak var mealDayCollectionView: UICollectionView!
    
    // property
    
    let viewModel = MainViewModel(mealService: MealService(), userService: UserService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()

    }
    
    private func configureUI() {
        chartView.makeShadow()
        mealCalendarView.makeShadow()
        consumeView.makeShadow()
        etcView.makeShadow()
        adviseView.makeShadow()
    }
    
    private func bindViewModel() {
        
        //input
        
        leftButton.rx.tap
            .map { [unowned self] _ -> [Meal] in
                return self.viewModel.mealService.fetchMealByNavigate(day: -1)
            }
            .subscribe(onNext: { [weak self] meals in
                self?.viewModel.output.mealDayList.onNext(meals)
            })
            .disposed(by: rx.disposeBag)
        
        rightButton.rx.tap
            .map { [unowned self] _ -> [Meal] in
                return self.viewModel.mealService.fetchMealByNavigate(day: 1)
            }
            .subscribe(onNext: { [weak self] meals in
                self?.viewModel.output.mealDayList.onNext(meals)
            })
            .disposed(by: rx.disposeBag)
        
        
        monthSelectButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
                vc.completionHandler = { date in
                    let newMeals = self?.viewModel.mealService.fetchMealByDay(day: date) ?? []
                    self?.viewModel.output.mealDayList.onNext(newMeals)
                }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .flipHorizontal
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addMealButton.rx.tap
            .subscribe(onNext: {
                
                // 현지님 여기다가 띄워주세요
                
                
            })
            .disposed(by: rx.disposeBag)
        
        //output
        
        
        viewModel.output.userInfo
            .drive(onNext: { user in
                self.userImage.image = UIImage(systemName: "person.circle")!
                self.userNickname.text = user.nickname
                self.userDetermination.text = user.determination
                self.userType.text = user.userType.rawValue
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.adviceString
            .drive(adviseLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        
        viewModel.output.mealDayList
            .bind(to: mealDayCollectionView.rx.items(cellIdentifier: "mainMealCell", cellType: MealDayCollectionViewCell.self)) { item, meal, cell in
                cell.updateUI(meal: meal)
            }
            .disposed(by: rx.disposeBag)
        
        // rx delegate
        mealDayCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
