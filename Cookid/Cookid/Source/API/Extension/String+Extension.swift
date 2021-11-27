//
//  String+Extension.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
//

import Foundation

extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.date(from: self)
    }
}
