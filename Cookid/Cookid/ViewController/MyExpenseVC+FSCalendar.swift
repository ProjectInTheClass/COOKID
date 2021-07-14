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
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("did select date \(self.dateFormatter.string(from: date))")
        
        let selectedDates = [date]
        
        updateData(dates: selectedDates)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        print("selected dates is \(selectedDates)")
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let deSelectedDate : [Date] = [date]
        
        updateData(dates: deSelectedDate)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if dineOutMeals.map({$0.date}).contains(date) {
            return .red
        }
        if dineInMeals.map({$0.date}).contains(date) {
            return .yellow
        }
        if shopping.map({$0.date}).contains(date) {
            return .blue
        }
        
//        if !(selectedShopping?.isEmpty ?? true) {
//            return .green
//        }
        return UIColor.clear
    }
    
}
