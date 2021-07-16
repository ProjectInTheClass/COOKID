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

class MyExpenseViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: MyExpenseViewModel!
    
    @IBOutlet weak var averageExpenseLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    var shopping : [GroceryShopping] = []
    var dineOutMeals : [Meal] = []
    var dineInMeals : [Meal] = []
    
    var data : [element] = []
    var selectedDineInMeals : [Meal] = []
    var selectedDineOutMeals : [Meal] = []
    var selectedShopping : [GroceryShopping] = []
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
        fetchShopping()
        fetchMeals()
        configureNavTab()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData(dates: [Date()])
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
        viewModel.output.updateShoppingList
            .drive(onNext: { [unowned self] (meals, shoppings) in
                
                self.dineOutMeals = meals.filter{$0.mealType == .dineOut}
                self.dineInMeals = meals.filter{$0.mealType == .dineIn}
                self.shopping = shoppings
                
                guard let selectedDate = calendar.selectedDate else { return }

                updateData(dates: [selectedDate])
                
                self.tableView.reloadData()
            })
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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        calendar.makeShadow()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.calendar.backgroundColor = .white
        self.calendar.appearance.headerDateFormat = "yyyy년 MM월"
        self.calendar.select(Date())
        self.calendar.scope = .month
        self.calendar.isMultipleTouchEnabled = true
        self.calendar.allowsMultipleSelection = false
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendar.appearance.titleTodayColor = .black
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.identifier)
    }
}

extension MyExpenseViewController {
    func fetchShopping() {
        
        viewModel.shoppingService.fetchGroceries(completion: { shoppings in
            self.shopping = shoppings
        })
    }
    
    func fetchMeals() {
        viewModel.mealService.fetchMeals(completion: { meals in
            self.dineOutMeals = meals.filter{$0.mealType == .dineOut}
            self.dineInMeals = meals.filter{$0.mealType == .dineIn}
        })
    }
    
    func findSelectedDateMeal (meals : [Meal], selectedDate : [Date]) -> [Meal] {
        var mealArr : [Meal] = []
        
        for date in selectedDate {
            mealArr = meals.filter{ $0.date.dateToString() == date.dateToString()}
        }
        return mealArr
    }
    
    func findSelectedDateShopping (shoppings : [GroceryShopping], selectedDate : [Date]) -> [GroceryShopping] {
        var shoppingArr : [GroceryShopping] = []
        
        for date in selectedDate {
            shoppingArr = shoppings.filter{$0.date.dateToString() == date.dateToString()}
        }
        return shoppingArr
    }
    
    func updateData (dates: [Date]) {
        data.removeAll()
        selectedDineOutMeals = findSelectedDateMeal(meals : self.dineOutMeals, selectedDate: dates)
        selectedDineInMeals = findSelectedDateMeal(meals : self.dineInMeals, selectedDate: dates)
        selectedShopping = findSelectedDateShopping(shoppings : self.shopping, selectedDate: dates)
        
        let dineOutElement = element(name: "외식", selected: selectedDineOutMeals)
        let dineInElement = element(name: "집밥", selected: selectedDineInMeals)
        let shoppingElement = element(name: "마트털이", selected: selectedShopping)
        
        let dataArr = [dineOutElement, dineInElement, shoppingElement]
        
        for i in 0...2 {
            if !dataArr[i].selected.isEmpty {
                data.append(dataArr[i])
            }
        }
    }
}

struct element {
   var name : String
   var selected : [Any]
}
