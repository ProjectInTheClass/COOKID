//
//  MyMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class MyMealViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: MyMealViewModel!
    
    @IBOutlet weak var dineStaticView: UIView!
    @IBOutlet weak var mostExpensiveStaticView: UIView!
    @IBOutlet weak var latestMealStaticView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        dineStaticView.makeShadow()
        mostExpensiveStaticView.makeShadow()
        latestMealStaticView.makeShadow()
        view.backgroundColor = .red
    }
    

    func bindViewModel() {
        
        
        
    }

}
