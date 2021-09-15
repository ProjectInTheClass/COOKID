//
//  Protocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift

protocol ViewModelBindable {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
    
}

extension ViewModelBindable where Self: UIViewController {
    mutating func bind(viewModel: ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension ViewModelBindable where Self: UITableViewCell {
    mutating func bind(viewModel: ViewModelType) {
        self.viewModel = viewModel
        reloadInputViews()
        bindViewModel()
    }
}

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

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
