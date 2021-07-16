//
//  Function.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import UIKit


func convertDateToString(format: String, date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let dateString = dateFormatter.string(from: date)
    return dateString
    
}

func stringToDate(date: String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
    let date = dateFormatter.date(from: date)
    
    return date!
}


extension Date {
    func dateToInt() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}

func hideKeyboard() {
   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}


func intToString(_ value: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let string = numberFormatter.string(from: NSNumber(value: value))! + " 원"
    return string
}
