//
//  Constant.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit

public enum DefaultStyle {
   
    public enum Color {
        public static let tint: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollection in
                    if traitCollection.userInterfaceStyle == .dark {
                        return .darkGray
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
        public static let labelTint: UIColor = {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == . dark {
                    return .white
                } else {
                    return .black
                }
            }
        }()
        public static let bgTint: UIColor = {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == . dark {
                    return #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
                } else {
                    return .white
                }
            }
        }()
    }
}

enum CELLIDENTIFIER {
    static let rankingCell = "rankingCell"
    static let rankingHeaderView = "rankingHeaderView"
    static let mainMealCell = "mainMealCell"
    static let mainShoppingCell = "mainShoppingCell"
    static let pictureSelectCell = "pictureSelectCell"
    static let menuCell = "menuCell"
    static let recipeCell = "recipeCell"
    static let postCell = "postCell"
}

enum NetWorkingError : String, Error {
    case fetchError = "서버에서 정보를 가져오는데 실패했습니다. made by 형석"
}

enum NetWorkingResult {
    case success(String)
    case post(Post)
    case comment(Comment)
}
