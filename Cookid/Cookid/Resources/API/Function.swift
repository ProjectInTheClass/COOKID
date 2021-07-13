//
//  Function.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/13.
//

import Foundation

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

func dateToInt(date: Date) -> Int {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "ko")
    let datecomponents = calendar.dateComponents([.year, .month], from: date)
    let startOfMonth = calendar.date(from: datecomponents)!
    return Int(startOfMonth.timeIntervalSince1970)
}
