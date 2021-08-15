//
//  Constant.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit

enum FBChild {
    static let groceries = "groceries"
    static let user = "user"
    static let meal = "meal"
}

public enum DefaultStyle {
   
    public enum Color {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollection in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .gray
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
    }
}

enum CELL_IDENTIFIER {
    static let rankingCell = "rankingCell"
    static let rankingHeaderView = "rankingHeaderView"
}

enum NetWorkingError : String, Error {
    case fetchError = "서버에서 유저 정보를 가져오는데 실패했습니다."
}