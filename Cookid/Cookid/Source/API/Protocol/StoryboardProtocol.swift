//
//  StoryboardProtocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/31.
//

import UIKit

protocol StoryboardBased {
    static func instantiate(storyboardID: String) -> Self
}

extension StoryboardBased where Self: UIViewController {
    static func instantiate(storyboardID: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
        // swiftlint:enable force_cast
    }
}
