//
//  MyExpenseVC+FSCalendar.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit
import FSCalendar


//MARK: - FSCalendar Setup
extension MyExpenseViewController : FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, UIGestureRecognizerDelegate{
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.snp.makeConstraints{
            $0.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        

        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})

        selectedDineOutMeals = dummyData.findSelectedDateMealData(target: dineOutMeals, selectedDate: date)
        selectedDineInMeals = dummyData.findSelectedDateMealData(target: dineInMeals, selectedDate: date)
        selectedShopping = dummyData.findSelectedDateShoppingData(target: shopping, selectedDate: date)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        print("selected dates is \(selectedDates)")

        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDineOutMeals = dummyData.findSelectedDateMealData(target: dineOutMeals, selectedDate: date)
        selectedDineInMeals = dummyData.findSelectedDateMealData(target: dineInMeals, selectedDate: date)
        selectedShopping = dummyData.findSelectedDateShoppingData(target: shopping, selectedDate: date)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        if dineOutMeals.map({$0.date}).contains(date) && shopping.map({$0.date}).contains(date) {
            return UIColor.red
        }
        if dineOutMeals.map({$0.date}).contains(date) {
            return UIColor.yellow
        }
        if shopping.map({$0.date}).contains(date) {
            return UIColor.blue
        }
        
        return UIColor.clear
    }

}
