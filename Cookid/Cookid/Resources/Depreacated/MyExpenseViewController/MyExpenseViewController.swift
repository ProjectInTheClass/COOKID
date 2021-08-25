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
import RxDataSources

class MyExpenseViewController: UIViewController, ViewModelBindable, StoryboardBased, UIScrollViewDelegate {
    
    var viewModel: MyExpenseViewModel!
    
    var dineOutMeals = [Meal]()
    var dineInMeals = [Meal]()
    var shoppings = [GroceryShopping]()
    var sections = [MealShoppingItemSectionModel]()
    
    @IBOutlet weak var averageExpenseLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
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
            .drive( onNext: { [unowned self] sections in
                self.sections = sections
            })
            .disposed(by: rx.disposeBag)
        
        let dataSource = MyExpenseViewController.dataSource()
        Observable.just(sections)
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
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
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
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
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        calendar.makeShadow()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.calendar.backgroundColor = .white
        self.calendar.appearance.headerDateFormat = "yyyy년 MM월"
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.calendar.isMultipleTouchEnabled = true
        self.calendar.allowsMultipleSelection = true
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendar.appearance.titleTodayColor = .black
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    static func dataSource() -> MealShoppingDataSource {
        return MealShoppingDataSource (configureCell: { dataSource , tableView, indexPath, _ in
            let cell: ExpenseTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell") as! ExpenseTableViewCell
            
            switch dataSource[indexPath] {
            case let .DineOutSectionItem(item):
                cell.updateCell(title: "\(item.price)원", date: item.date.dateToString())
            case let .DineInSectionItem(item):
                cell.updateCell(title: "\(item.price)원", date: item.date.dateToString())
            case let .ShoppingSectionItem(item):
                cell.updateCell(title: "\(item.totalPrice)원", date: item.date.dateToString())
            }
            return cell
        },
        titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        },
        canEditRowAtIndexPath: { _, _ in
            return true
        }
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

