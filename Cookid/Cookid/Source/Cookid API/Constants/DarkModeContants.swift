//
//  DarkModeContants.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
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
