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
import FirebaseAnalytics
import RxDataSources

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
    @IBOutlet weak var mealType: UILabel!
    @IBOutlet weak var mealtimeCollectionBGView: UIView!
    @IBOutlet weak var mealTimeCollectionView: UICollectionView!
    
    @IBOutlet weak var recentMealView: UIView!
    @IBOutlet weak var recentMealTableView: UITableView!
    
    // property
    
    var viewModel: MainViewModel!
    var coordinator: MainCoordinator?
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
        recentMealView.makeShadow()
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
            .bind(to: viewModel.input.leftButtonTapped)
            .disposed(by: rx.disposeBag)
        
        rightButton.rx.tap
            .bind(to: viewModel.input.rightButtonTapped)
            .disposed(by: rx.disposeBag)
        
        monthSelectButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateSelectCalendarVC(viewModel: self.viewModel)
            })
            .disposed(by: rx.disposeBag)
        
        todayMealButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddTodayMeal()
                Analytics.logEvent("addMeal_todayMeals", parameters: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addMealButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddMealVC(mode: .new)
                Analytics.logEvent("addMeal_meal", parameters: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addShoppingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                coordinator?.navigateAddShoppingVC(mode: .new)
                Analytics.logEvent("addShopping_shopping", parameters: nil)
            })
            .disposed(by: rx.disposeBag)
        
        // MARK: - bindViewModel output
        
        viewModel.output.selectedDate
            .withUnretained(self)
            .bind(onNext: { owner, date in
                owner.monthSelectButton.setTitle(convertDateToString(format: "YYYY년 M월 d일", date: date), for: .normal)
            })
            .disposed(by: rx.disposeBag)
        
        // X
        viewModel.output.recentMeals
            .bind(to: recentMealTableView.rx.items(cellIdentifier: "recentMeals", cellType: MealTableViewCell.self)) { _, item, cell in
                cell.updateUI(meal: item)
            }
            .disposed(by: rx.disposeBag)
        
        Observable.zip(recentMealTableView.rx.modelSelected(Meal.self), recentMealTableView.rx.itemSelected)
            .bind(onNext: { [unowned self] meal, indexPath in
                self.recentMealTableView.deselectRow(at: indexPath, animated: false)
                self.coordinator?.navigateAddMealVC(mode: .edit(meal))
            })
            .disposed(by: rx.disposeBag)
        
        // X
        viewModel.output.averagePrice
            .bind(onNext: { [unowned self] str in
                self.averageLabel.text = str
            })
            .disposed(by: rx.disposeBag)
        
        // O
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
        
        // O
        viewModel.output.adviceString
            .bind(to: adviseLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        // O
        viewModel.output.monthlyDetailed
            .bind(onNext: { [unowned self] detail in
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
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [unowned self] value in
                self.chartPercentLabel.text = String(format: "%.0f", value) + "%"
                self.consumeProgressBar.progress = CGFloat(value) / CGFloat(100)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.mealDayList
                .bind(to: mealDayCollectionView.rx.items(dataSource: createDataSource()))
                .disposed(by: rx.disposeBag)
                
        mealDayCollectionView.rx.modelSelected(MainCollectionViewItem.self)
                .withUnretained(self)
                .bind(onNext: { owner, item in
                    switch item {
                    case .meals(let meal):
                        owner.coordinator?.navigateAddMealVC(mode: .edit(meal))
                    case .shoppings(let shopping):
                        owner.coordinator?.navigateAddShoppingVC(mode: .edit(shopping))
                    }
                })
                .disposed(by: rx.disposeBag)
                
                // rx delegate
                mealDayCollectionView.rx.setDelegate(self)
                .disposed(by: rx.disposeBag)
                
        viewModel.output.dineInProgress
                .delay(.microseconds(500), scheduler: MainScheduler.instance)
                .bind(onNext: { [unowned self] progress in
                    self.dineInProgressBar.progress = progress
                })
                .disposed(by: rx.disposeBag)
                
        viewModel.output.mostExpensiveMeal
                .bind(onNext: { [unowned self] meal in
                    self.mealName.text = meal.name
                    self.mealPrice.text = intToString(meal.price)
                    self.mealImage.image = meal.image ?? UIImage(systemName: "circle.fill")
                    self.mealType.text = meal.mealType.rawValue
                })
                .disposed(by: rx.disposeBag)
                
        viewModel.output.mealtimes
                .do(onNext: { [weak self] mealses in
                    let numArr = mealses.map { $0.count }
                    self?.maxValue = numArr.max()
                })
                .bind(to: mealTimeCollectionView.rx.items(cellIdentifier: "timeCell", cellType: MealTimeCollectionViewCell.self)) { _, meals, cell in
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
         
        viewModel.shoppingService.fetchShoppings()
        viewModel.mealService.fetchMeals()
        
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainCollectionViewSection> {
        typealias DataSource = RxCollectionViewSectionedReloadDataSource
        let ds = DataSource<MainCollectionViewSection> { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .meals(meal: let meal):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.mainMealCell, for: indexPath) as? MealDayCollectionViewCell else { return UICollectionViewCell() }
                cell.updateUI(meal: meal)
                return cell
                
            case .shoppings(shopping: let shopping):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER.mainShoppingCell, for: indexPath) as? ShoppingCollectionViewCell else { return UICollectionViewCell() }
                cell.updateUI(shopping: shopping)
                return cell
            }
        }
        return ds
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
