//
//  MyExpenseViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import FSCalendar
import SnapKit
import Then
import RxSwift

class MyExpenseViewController: UIViewController, ViewModelBindable, StoryboardBased, UIScrollViewDelegate {
  
    var viewModel: MyExpenseViewModel!
    
    var dineOutMeals = [Meal]()
    var dineInMeals = [Meal]()
    var shoppings = [GroceryShopping]()
    
    
    @IBOutlet weak var averageExpenseLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
        configureNavTab()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureNavTab() {
        self.navigationItem.title = "식비 관리 🛒"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.tabBarItem.image = UIImage(systemName: "cart")
        self.tabBarItem.selectedImage = UIImage(systemName: "cart.fill")
        self.tabBarItem.title = "식비 관리"
    }
    
    func bindViewModel() {
        
        Observable.of(calendar.selectedDates)
         .bind(to: viewModel.input.selectedDates)
         .disposed(by: rx.disposeBag)
        
        viewModel.output.averagePrice
            .drive(onNext: { str in
                self.averageExpenseLabel.text = str
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.updateData
            .drive(onNext: { [unowned self] (dineOutMeals, dineInMeals, shoppings) in

                self.dineOutMeals = dineOutMeals
                self.dineInMeals = dineInMeals
                self.shoppings = shoppings
                
                calendar.reloadData()
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.updateDataBySelectedDates
            .drive( onNext: { dineOutMeals, dineInMeals, shoppings in
                Observable.of(dineOutMeals)
                    .bind(to: self.listTableView.rx.items(cellIdentifier: "ExpenseTableViewCell", cellType: ExpenseTableViewCell.self)) { row, element, cell in
                        cell.updateUI(title: "\(element.price)원", date: element.date.dateToString())
                    }
                    .disposed(by: self.rx.disposeBag)
                Observable.of(dineInMeals)
                    .bind(to: self.listTableView.rx.items(cellIdentifier: "ExpenseTableViewCell", cellType: ExpenseTableViewCell.self)) { row, element, cell in
                        cell.updateUI(title: "\(element.price)원", date: element.date.dateToString())
                    }
                    .disposed(by: self.rx.disposeBag)
                Observable.of(shoppings)
                    .bind(to: self.listTableView.rx.items(cellIdentifier: "ExpenseTableViewCell", cellType: ExpenseTableViewCell.self)) { row, element, cell in
                        cell.updateUI(title: "\(element.totalPrice)원", date: element.date.dateToString())
                    }
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
        
//        listTableView.rx.setDelegate(self)
//            .disposed(by: rx.disposeBag)

    }
    
    deinit {
        print("\(#function)")
    }
    
    // MARK:- UIGestureRecognizerDelegate
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.listTableView.contentOffset.y <= -self.listTableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }
}

extension MyExpenseViewController {
    //MARK: - constraints Setup
    func setUpConstraint() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        calendar.makeShadow()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.listTableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.calendar.backgroundColor = .white
        self.calendar.appearance.headerDateFormat = "yyyy년 MM월"
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.calendar.isMultipleTouchEnabled = true
        self.calendar.allowsMultipleSelection = false
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendar.appearance.titleTodayColor = .black
        
        self.listTableView.rowHeight = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}
