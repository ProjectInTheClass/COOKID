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

    var sections = ["집밥", "외식", "마트털이"]
    
    var selectedDineInMeals : [Meal]? = []
    var selectedDineOutMeals : [Meal]? = []
    var selectedShopping : [GroceryShopping]? = []
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let monthlyExpenseLabel = UILabel().then{
        $0.text = "\(DummyData.shared.singleUser.priceGoal)" + "원"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 40)
    }
    
    let averageDailyExpenseLabel = UILabel().then{
        $0.text = "하루평균 지출 금액은 5000원입니다."
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    lazy var calendar = FSCalendar().then{
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.headerDateFormat = "yyyy년 MM월"
        $0.select(Date())
        $0.scope = .month
        $0.isMultipleTouchEnabled = true
        $0.allowsMultipleSelection = false
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.titleTodayColor = .black
    }
    
    lazy var tableView = UITableView().then{
        $0.delegate = self
        $0.dataSource = self
        
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
        fetchShopping()
        fetchMeals()
    }
    
    deinit {
        print("\(#function)")
    }
}

extension MyExpenseViewController {
    func fetchShopping() {
        MealService.shared.fetchGroceries(completion: { shoppings in
            self.shopping = shoppings
        })
    }
    
    func fetchMeals() {
        MealService.shared.fetchMeals2(completion: { newMeals in
            self.meal = newMeals
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
        self.view.addSubview(monthlyExpenseLabel)
        self.view.addSubview(averageDailyExpenseLabel)
        self.view.addSubview(calendar)
        self.view.addSubview(tableView)
        
        //monthlyExpenseLabel constraint
        self.monthlyExpenseLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(40)
        }
        
        //averageDailyExpenseLabel constraint
        self.averageDailyExpenseLabel.snp.makeConstraints{
            $0.top.equalTo(monthlyExpenseLabel.snp.bottom)
            $0.leading.trailing.equalTo(monthlyExpenseLabel)
            $0.height.equalTo(20)
        }
        
        //calnedar constraint
        self.calendar.snp.makeConstraints{
            $0.top.equalTo(averageDailyExpenseLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        //tableview constraint
        self.tableView.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalTo(calendar)
            $0.bottom.equalToSuperview()
        }
    }
}
