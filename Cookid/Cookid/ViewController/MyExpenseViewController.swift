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

class MyExpenseViewController: UIViewController {
    
    @IBOutlet weak var averageExpenseLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    let shoppingService = ShoppingService()
    let mealService = MealService()
    
    var meal : [Meal] = []
    var shopping : [GroceryShopping] = []
    
    lazy var dineOutMeals : [Meal] = {
        let dineOutMeals = meal.filter{$0.mealType == .dineOut}
        return dineOutMeals
    }()
    
    lazy var dineInMeals : [Meal] = {
        let dineInMeals = meal.filter{$0.mealType == .dineIn}
        return dineInMeals
    }()
    
    var selectedDineInMeals : [Meal] = []
    var selectedDineOutMeals : [Meal] = []
    var selectedShopping : [GroceryShopping] = []
    var data : [element] = []
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
        fetchShopping()
        fetchMeals()
    }
    
    deinit {
        print("\(#function)")
    }
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
}

extension MyExpenseViewController {
    func fetchShopping() {
        shoppingService.fetchGroceries(completion: { shoppings in
            self.shopping = shoppings
        })
    }
    
    func fetchMeals() {
        mealService.fetchMeals(completion: { meals in
            self.meal = meals
        })
    }
    
    func findSelectedDateMealData (meals : [Meal], selectedDate : [Date]) -> [Meal] {
        var mealArr : [Meal] = []
        
        for date in selectedDate {
            mealArr = meals.filter{ $0.date.dateToString() == date.dateToString() }
        }
        return mealArr
    }
    
    func findSelectedDateShoppingData (shoppings : [GroceryShopping], selectedDate : [Date]) -> [GroceryShopping] {
        var shoppingArr : [GroceryShopping] = []
        
        for date in selectedDate {
            shoppingArr = shoppings.filter{$0.date.dateToString() == date.dateToString()}
        }
        return shoppingArr
    }
    
    //MARK: - constraints Setup
    func setUpConstraint() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        self.averageExpenseLabel.text = "하루평균 지출 금액은 5000원입니다."
        self.averageExpenseLabel.textColor = .darkGray
        self.averageExpenseLabel.font = .systemFont(ofSize: 15)
        
        self.calendar.backgroundColor = .white
        self.calendar.locale = Locale(identifier: "ko_KR")
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
        
        // MARK:- UIGestureRecognizerDelegate
        
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
    
    func updateData (dates: [Date]) {
        selectedDineOutMeals = findSelectedDateMealData(meals : dineOutMeals, selectedDate: dates)
        selectedDineInMeals = findSelectedDateMealData(meals : dineInMeals, selectedDate: dates)
        selectedShopping = findSelectedDateShoppingData(shoppings : shopping, selectedDate: dates)
        
        data = [ element(name: "외식", selected: selectedDineOutMeals), element(name: "집밥", selected: selectedDineInMeals), element(name: "마트털이", selected: selectedShopping)]
    }
    
    struct element {
       var name : String
       var selected : [Any]
    }
}
