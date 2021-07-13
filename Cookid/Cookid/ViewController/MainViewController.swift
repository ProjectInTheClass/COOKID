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
    @IBOutlet weak var userImage: UILabel!
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
    @IBOutlet weak var consumeProgressBar: PlainCircleProgressBar!
    @IBOutlet weak var chartPercentLabel: UILabel!
    
    // mealCalendarView
    @IBOutlet weak var mealCalendarView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var monthSelectButton: UIButton!
    @IBOutlet weak var mealDayCollectionView: UICollectionView!
    
    // property
    
    let viewModel = MainViewModel(mealService: MealService(), userService: UserService(), shoppingService: ShoppingService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        MealRepository.shared.fetchMeals { meal in
            print(meal)
        }
    }
    
    private func configureUI() {
        chartView.makeShadow()
        mealCalendarView.makeShadow()
        consumeView.makeShadow()
        etcView.makeShadow()
        adviseView.makeShadow()
        monthSelectButton.setTitle(Date().dateToString(), for: .normal)
    }
    
    private func bindViewModel() {
        
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
//
//                let inputMealView = InputMealView(dismissView: {self.dismiss(animated: true, completion: nil)})
//                let vc = InputMealViewController(rootView: inputMealView)
//
//                vc.modalPresentationStyle = .formSheet
//                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        addShoppingButton.rx.tap
            .subscribe(onNext: {
                let inputShoppingDataView = InputDataShoppingViewController()
                
                self.presentPanModal(inputShoppingDataView)
                
                print("석현님 여기다가 VC 띄워주세요")
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
                self.chartPercentLabel.text = String(value) + "%"
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
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
