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
    @IBOutlet weak var todayMealButton: UIButton!
    
    // consumeView
    @IBOutlet weak var consumeView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var priceGoalLabel: UILabel!
    @IBOutlet weak var shoppingPrice: UILabel!
    @IBOutlet weak var dineOutPrice: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    // adviseView
    @IBOutlet weak var adviseView: UIView!
    @IBOutlet weak var adviseLabel: UILabel!
    @IBOutlet weak var averageView: UIView!
    @IBOutlet weak var averageLabel: UILabel!
    
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

    // My Meal
    @IBOutlet weak var dineStaticView: UIView!
    @IBOutlet weak var mostExpensiveStaticView: UIView!
    @IBOutlet weak var dineInCircleView: UIView!
    @IBOutlet weak var dineOutCircleView: UIView!
    @IBOutlet weak var dineInProgressBar: PlainHorizontalProgressBar!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealtimeCollectionBGView: UIView!
    @IBOutlet weak var mealTimeCollectionView: UICollectionView!

    // property
    
    var viewModel: MainViewModel!
    var coordinator: MainCoordinator?
    var currentDay = Date()
    var maxValue: Int? = 1
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        LocalNotificationManager.setNotification()
    }
    
    // MARK: - Functions
    
    private func configureUI() {
        addMealButton.layer.cornerRadius = 8
        addShoppingButton.layer.cornerRadius = 8
        todayMealButton.layer.cornerRadius = 8
        chartView.makeShadow()
        mealCalendarView.makeShadow()
        consumeView.makeShadow()
        etcView.makeShadow()
        adviseView.makeShadow()
        averageView.makeShadow()
        dineStaticView.makeShadow()
        mealtimeCollectionBGView.makeShadow()
        mostExpensiveStaticView.makeShadow()
        dineInCircleView.makeCircleView()
        dineOutCircleView.makeCircleView()
        mealImage.makeCircleView()
        configureNavTab()
        monthSelectButton.setTitle(Date().dateToString(), for: .normal)
        adviseLabel.textColor = DefaultStyle.Color.labelTint
        averageLabel.textColor = DefaultStyle.Color.labelTint
        userDetermination.textColor = DefaultStyle.Color.tint
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
        
        leftButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let date = self.viewModel.fetchMealByNavigate(-1, currentDate: self.currentDay)
                self.viewModel.input.selectedDate.accept(date)
            })
            .disposed(by: rx.disposeBag)
        
        rightButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let date = self.viewModel.fetchMealByNavigate(1, currentDate: self.currentDay)
                self.viewModel.input.selectedDate.accept(date)
            })
            .disposed(by: rx.disposeBag)
        
        monthSelectButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateSelectCalendarVC(viewModel: self.viewModel)
            })
            .disposed(by: rx.disposeBag)
        
        todayMealButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddMealVC(viewModel: self.viewModel, meal: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addMealButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddMealVC(viewModel: self.viewModel, meal: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addShoppingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddShoppingVC(viewModel: self.viewModel, shopping: nil)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.input.selectedDate
            .bind(onNext: { [unowned self] date in
                self.currentDay = date
                self.monthSelectButton.setTitle(convertDateToString(format: "YYYY년 M월 d일", date: date), for: .normal)
            })
            .disposed(by: rx.disposeBag)
        
        // MARK: - bindViewModel output
        
        viewModel.output.averagePrice
            .drive(onNext: { [unowned self] str in
                self.averageLabel.text = str
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.userInfo
            .bind(onNext: { user in
                self.userNickname.text = user.nickname
                self.userDetermination.text = user.determination
                self.userType.text = user.userType.rawValue
                switch user.userType {
                case .preferDineIn:
                    self.userImage.text = "🍚"
                case .preferDineOut:
                    self.userImage.text = "🍟"
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
            .drive(onNext: { [unowned self] value in
                self.chartPercentLabel.text = String(format: "%.0f", value) + "%"
                self.consumeProgressBar.progress = CGFloat(value) / CGFloat(100)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealDayList
            .drive(mealDayCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        mealDayCollectionView.rx.modelSelected(MainCollectionViewItem.self)
            .subscribe(onNext: { [unowned self] item in
                switch item {
                case .meals(meal: let meal):
                    self.coordinator?.navigateAddMealVC(viewModel: self.viewModel, meal: meal)
                case .shoppings(shopping: let shopping):
                    self.coordinator?.navigateAddShoppingVC(viewModel: self.viewModel, shopping: shopping)
                }
            })
            .disposed(by: rx.disposeBag)
        
        // rx delegate
        mealDayCollectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
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
                self.mealImage.image = meal.image ?? UIImage(systemName: "circle.fill")
            })
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
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mealTimeCollectionView {
            return CGSize(width: collectionView.frame.width/6 - 5, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        }
    }
}
