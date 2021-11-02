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
    let date = dateFormatter.date(from: date)!
    return date
}

func stringToDateKr(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
    let date = dateFormatter.date(from: string)!
    return date
}

extension Date {
    func dateToInt() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}

func intToString(_ value: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let string = numberFormatter.string(from: NSNumber(value: value))! + "원"
    return string
}

func intToStringRemoveVer(_ value: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let string = numberFormatter.string(from: NSNumber(value: value))!
    return string
}

func mealTypeToBool(_ mealType: MealType) -> Bool {
    switch mealType {
    case .dineIn:
        return true
    case .dineOut:
        return false
    }
}

func errorAlert(selfView: UIViewController, errorMessage: String?, completion: @escaping () -> Void) {
    let alert = UIAlertController(title: "에러 발생 😥", message: errorMessage, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
        alert.dismiss(animated: true, completion: nil)
        completion()
    }
    alert.addAction(okAction)
    selfView.present(alert, animated: true, completion: nil)
}


// MARK: - Validation

private let charSet: CharacterSet = {
    var cs = CharacterSet(charactersIn: "0123456789")
    return cs.inverted
}()

func validationNum(text: String) -> Bool {
    if text.isEmpty && text == "" {
        return false
    } else {
        guard text.rangeOfCharacter(from: charSet) == nil else { return false }
        return true
    }
}

func validationNumOptional(text: String?) -> Bool? {
    guard let text = text, text != "" else { return nil }
    if text.isEmpty {
        return false
    } else {
        guard text.rangeOfCharacter(from: charSet) == nil else { return false }
        return true
    }
}

func validationNumForPrice(text: String?) -> Bool? {
    guard let text = text, text != "" else { return nil }
    guard text.rangeOfCharacter(from: charSet) == nil else { return false }
    return true
}

