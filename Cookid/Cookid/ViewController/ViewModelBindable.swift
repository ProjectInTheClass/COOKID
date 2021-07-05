//
//  ViewModelBindable.swift
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

