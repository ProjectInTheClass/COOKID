//
//  Protocol.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

protocol ViewModelBindable {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
    
}

extension ViewModelBindable where Self: UIViewController {
    mutating func bind(viewModel: ViewModelType) {
        self.viewModel = viewModel
        bindViewModel()
        loadViewIfNeeded()
      
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
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}


