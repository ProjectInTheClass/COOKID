//
//  MyRecipesViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/08.
//

import UIKit

class MyRecipesViewController: UIViewController, ViewModelBindable {

    var viewModel: MyPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    func bindViewModel() {
        
    }

}
