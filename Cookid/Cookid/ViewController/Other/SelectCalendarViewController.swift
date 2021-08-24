//
//  SelectCalendarViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import NSObject_Rx

class SelectCalendarViewController: UIViewController, StoryboardBased, ViewModelBindable {
   
    var viewModel: MainViewModel!
    var dineInMeals = [Meal]()
    var dineOutMeals = [Meal]()
    var shoppings = [GroceryShopping]()
    
    @IBOutlet weak var updateCalendar: FSCalendar!
    @IBOutlet weak var dimmingButton: UIButton!
    @IBOutlet weak var calendarBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForUpdateCalendar()
    }
    
    private func initializeForUpdateCalendar() {
        //utility
        updateCalendar.select(Date())
        updateCalendar.delegate = self
        updateCalendar.dataSource = self
        updateCalendar.scope = .month
        updateCalendar.backgroundColor = .white
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // header
        updateCalendar.headerHeight = 70
        updateCalendar.appearance.headerTitleColor = UIColor.black
        updateCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        updateCalendar.appearance.headerDateFormat = "YYYY년 MM월"
        updateCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24, weight: .light)
        
        // week
        updateCalendar.appearance.weekdayTextColor = UIColor.darkGray
        updateCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 13, weight: .light)
        updateCalendar.locale = Locale(identifier: "ko_KR")
        
        //body
        calendarBackground.makeShadow()
        updateCalendar.appearance.titleTodayColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        updateCalendar.appearance.todayColor = .clear
        updateCalendar.appearance.todaySelectionColor = .darkGray
        updateCalendar.appearance.selectionColor = .darkGray
        updateCalendar.appearance.eventDefaultColor = .lightGray
    }
    
    func bindViewModel() {

        dimmingButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.basicMeal
            .bind(onNext: { [unowned self] meals in
                self.dineOutMeals = meals.filter { $0.mealType == .dineOut }
                self.dineInMeals = meals.filter { $0.mealType == .dineIn }
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.basicShopping
            .bind(onNext: { [unowned self] shoppings in
                self.shoppings = shoppings
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.input.selectedDate
            .bind(onNext: { [unowned self] date in
                updateCalendar.select(date)
            })
            .disposed(by: rx.disposeBag)
        
    }
}

extension SelectCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.input.selectedDate.onNext(date)
        self.dismiss(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let isOut = dineOutMeals.map({$0.date.dateToString()}).contains(date.dateToString())
        let isIn = dineInMeals.map({$0.date.dateToString()}).contains(date.dateToString())
        let isShop = shoppings.map({$0.date.dateToString()}).contains(date.dateToString())
        
        if isOut && isIn && isShop {
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        } else if (isOut || isIn) && !isShop {
            return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else if isShop && !(isIn || isOut) {
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        } else if isShop && isIn || isShop && isOut {
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        return UIColor.clear
    }
    
    
}
