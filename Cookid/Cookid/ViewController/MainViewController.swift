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
    
    @IBAction func create(_ sender: Any) {
        print("view")
        viewModel.mealService.create(meal: DummyData.shared.mySingleMeal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNotification()
        setFirstView()
    }
    
    private func configureUI() {
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
        
        //input
        
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
                let vc = SelectCalendarViewController.instantiate(storyboardID: "Main")
                vc.completionHandler = { date in
                    let data = self.viewModel.mealService.fetchMealByDay(date)
                    self.monthSelectButton.setTitle(data.0, for: .normal)
                    self.viewModel.input.todayMeals.onNext(data.1)
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addMealButton.rx.tap
            .subscribe(onNext: {
                let vc = InputMealViewController()
                vc.saveMeal = { meal in self.viewModel.mealService.create(meal: meal) }
                vc.modalPresentationStyle = .formSheet
                self.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: rx.disposeBag)
        
        addShoppingButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let vc = InputDataShoppingViewController(service: self.viewModel.shoppingService)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
                
            })
            .disposed(by: rx.disposeBag)
        
        userInfoUpdateButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                
                var vc = UserInformationViewController.instantiate(storyboardID: "UserInfo")
                vc.bind(viewModel: viewModel)
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        //output
        
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
                self.priceGoalLabel.text = String(detail.priceGoal)
                self.shoppingPrice.text = String(detail.shoppingPrice)
                self.dineOutPrice.text = String(detail.dineOutPrice)
                self.balanceLabel.text = String(detail.balance)
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
                let mealDatailView = MealDetailView(
                    deleteTapped: {
                        self.viewModel.mealService.delete(meal: meal)
                        self.dismiss(animated: true, completion: nil)
                    },
                    saveTapped: { meal in 
                        self.viewModel.mealService.update(updateMeal: meal)
                        self.dismiss(animated: true, completion: nil)
                    },
                    cancelTapped: {
                        self.dismiss(animated: true, completion: nil)
                    },
                    meal: meal)
                let vc = UIHostingController(rootView: mealDatailView)
                vc.modalPresentationStyle = .custom
                vc.view.backgroundColor = .clear
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
            
        
    }
    
    private func setNotification(){
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
            print("사용자 동의 --> \(granted)")
        }
        
        let content = UNMutableNotificationContent()
        content.title = "새로운 달입니다!"
        content.body = "새로운 가계부 진행시켜 🏃‍♀️"
        
        var datComp = DateComponents()
        datComp.day = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setFirstView(){
        
//        if Auth.auth().currentUser == nil {
//            let vc = OnboardingPageViewViewController()
//            present(vc, animated: false, completion: nil)
//        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
