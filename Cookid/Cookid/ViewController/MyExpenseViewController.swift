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

    var dummyData = DummyData.shared

    var dineOutMeals : [Meal] = DummyData.shared.myMeals.filter{$0.mealType == .dineOut}
    var dineInMeals : [Meal] = DummyData.shared.myMeals.filter{$0.mealType == .dineIn}
    var shopping : [GroceryShopping] = DummyData.shared.myShoppings

    var sections = ["집밥", "외식", "마트털이"]

    
    var mealDates : [Date?] = []
    var shoppingDates : [Date?] = []
    
    var selectedDineInMeals : [Meal?] = []
    var selectedDineOutMeals : [Meal?] = []
    var selectedShopping : [GroceryShopping?] = []
    
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
        $0.allowsMultipleSelection = false
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.titleTodayColor = .black
    }
    
    lazy var tableView = UITableView().then{
        $0.delegate = self
        $0.dataSource = self
        
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        
        $0.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        $0.panGestureRecognizer.require(toFail: self.scopeGesture)
    }
    
     lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraint()
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    //MARK: - constraints Setup
    func setUpConstraint() {
        self.view.addSubview(monthlyExpenseLabel)
        self.view.addSubview(averageDailyExpenseLabel)
        self.view.addSubview(calendar)
        self.view.addSubview(tableView)
                
        //Gesture 추가
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        
        //monthlyExpenseLabel constraint
        self.monthlyExpenseLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        //averageDailyExpenseLabel constraint
        self.averageDailyExpenseLabel.snp.makeConstraints{
            $0.top.equalTo(monthlyExpenseLabel.snp.bottom)
            $0.leading.trailing.equalTo(monthlyExpenseLabel)
        }
        
        //calnedar constraint
        self.calendar.snp.makeConstraints{
            $0.top.equalTo(averageDailyExpenseLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIDevice.current.model.hasPrefix("iPad") ? 400 : 300)
        }
        
        //tableview constraint
        self.tableView.snp.makeConstraints{
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalTo(calendar)
            $0.bottom.equalToSuperview()
        }
    }
}
