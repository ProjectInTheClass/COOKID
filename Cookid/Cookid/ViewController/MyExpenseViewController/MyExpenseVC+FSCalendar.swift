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

        self.updateData(dates: calendar.selectedDates)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        updateData(dates: calendar.selectedDates)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
       
        
        let isOut = dineOutMeals.map({$0.date.dateToString()}).contains(date.dateToString())
        let isIn = dineInMeals.map({$0.date.dateToString()}).contains(date.dateToString())
        let isShop = shopping.map({$0.date.dateToString()}).contains(date.dateToString())
        
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
