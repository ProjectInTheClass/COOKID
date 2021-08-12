//
//  MainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import NSObject_Rx
import Firebase

class MainViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - IBOutlet
    
    // userview
    @IBOutlet weak var etcView: UIView!
    @IBOutlet weak var userImage: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userDetermination: UILabel!
    @IBOutlet weak var userInfoUpdateButton: UIButton!
    
    // buttonView
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet weak var addShoppingButton: UIButton!
    @IBOutlet weak var rankingButton: UIBarButtonItem!
    
    
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
    @IBOutlet weak var consumeProgressBar: PlainCircleProgressBar!
    @IBOutlet weak var chartPercentLabel: UILabel!
    
    // mealCalendarView
    @IBOutlet weak var mealCalendarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var monthSelectButton: UIButton!
    @IBOutlet weak var mealDayCollectionView: UICollectionView!

    // property
    
    var viewModel: MainViewModel!
    var coordinator: HomeCoordinator?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Functions
    
    private func configureUI() {
        addMealButton.layer.cornerRadius = 8
        addShoppingButton.layer.cornerRadius = 8
        chartView.makeShadow()
        mealCalendarView.makeShadow()
        consumeView.makeShadow()
        etcView.makeShadow()
        adviseView.makeShadow()
        configureNavTab()
        monthSelectButton.setTitle(Date().dateToString(), for: .normal)
    }
    
    private func configureNavTab() {
        self.navigationItem.title = "\(Date().convertDateToString(format: "M월")) 목표 🏳️‍🌈"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.tabBarItem.image = UIImage(systemName: "house")
        self.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        self.tabBarItem.title = "나의 목표"
    }
    
    func bindViewModel() {
        
        // MARK: - bindViewModel input
        
        rankingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.coordinator?.navigateRankingVC()
            })
            .disposed(by: rx.disposeBag)
        
        leftButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let data = self.viewModel.mealService.fetchMealByNavigate(-1)
                self.monthSelectButton.setTitle(data.0, for: .normal)
                self.viewModel.input.yesterdayMeals.onNext(data.1)
            })
            .disposed(by: rx.disposeBag)
        
        rightButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let data = self.viewModel.mealService.fetchMealByNavigate(1)
                self.monthSelectButton.setTitle(data.0, for: .normal)
                self.viewModel.input.tommorowMeals.onNext(data.1)
            })
            .disposed(by: rx.disposeBag)
        
        monthSelectButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateSelectCalendarVC(viewModel: self.viewModel, button: self.monthSelectButton)
            })
            .disposed(by: rx.disposeBag)
        
        addMealButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddMealVC(viewModel: self.viewModel, meal: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addShoppingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddShoppingVC(viewModel: self.viewModel)
            })
            .disposed(by: rx.disposeBag)
        
        userInfoUpdateButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateUserInfoVC(viewModel: self.viewModel)
            })
            .disposed(by: rx.disposeBag)
        
        // MARK: - bindViewModel output
        
        viewModel.output.userInfo
            .drive(onNext: { user in
                self.userNickname.text = user.nickname
                self.userDetermination.text = user.determination
                switch user.userType {
                case .preferDineIn:
                    self.userImage.text = "🍚"
                    self.userType.text = user.userType.rawValue
                case .preferDineOut:
                    self.userImage.text = "🍟"
                    self.userType.text = user.userType.rawValue
                }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.adviceString
            .drive(adviseLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.monthlyDetailed
            .drive(onNext: { [unowned self] detail in
                self.monthLabel.text = detail.month
                self.priceGoalLabel.text = intToStringRemoveVer(detail.priceGoal)
                self.shoppingPrice.text = intToString(detail.shoppingPrice)
                self.dineOutPrice.text = intToString(detail.dineOutPrice)
                self.balanceLabel.text = intToString(detail.balance)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.consumeProgressCalc
            .do(onNext: { [unowned self] _ in
                self.consumeProgressBar.progress = 0
            })
            .delay(.milliseconds(500))
            .drive(onNext: {
                [unowned self] value in
                self.chartPercentLabel.text = String(format: "%.0f", value) + "%"
                self.consumeProgressBar.progress = CGFloat(value) / CGFloat(100)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealDayList
            .drive(mealDayCollectionView.rx.items(cellIdentifier: "mainMealCell", cellType: MealDayCollectionViewCell.self)) { item, meal, cell in
                cell.updateUI(meal: meal)
            }
            .disposed(by: rx.disposeBag)
        
        // rx delegate
        mealDayCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        Observable.zip(mealDayCollectionView.rx.modelSelected(Meal.self), mealDayCollectionView.rx.itemSelected)
            .observe(on: MainScheduler.instance)
            .do(onNext: { _, indexPath in
                self.mealDayCollectionView.deselectItem(at: indexPath, animated: false)
            })
            .subscribe(onNext: { [unowned self] meal, _ in
                coordinator?.navigateAddMealVC(viewModel: self.viewModel, meal: meal)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
