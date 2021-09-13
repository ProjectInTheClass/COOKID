//
//  Constant.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/06.
//

import UIKit
import KakaoSDKAuth

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
    case failure
    case hasNoToken = "토큰을 얻어오지 못했습니다."
    case fetchError = "서버에서 정보를 가져오는데 실패했습니다."
    case signInError = "로그인에 성공하지 못했습니다."
    case networkError = "네트워크에서 정상적인 작동이 이루어지지 않았습니다."
}

enum NetWorkingResult : String {
    case successSignIn = "로그인에 성공했습니다!"
    case token
}

enum IMAGENAME {
    static let placeholder = "placeholder"
}
