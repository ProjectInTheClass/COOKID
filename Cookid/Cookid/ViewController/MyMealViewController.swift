//
//  MyMealViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import RxSwift
import RxCocoa

class MyMealViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: MyMealViewModel!
    
    @IBOutlet weak var dineStaticView: UIView!
    @IBOutlet weak var mostExpensiveStaticView: UIView!
    @IBOutlet weak var latestMealStaticView: UIView!
    
    @IBOutlet weak var dineInProgressBar: PlainHorizontalProgressBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        progresstimer()
    }
    
    private func configureUI() {
        dineStaticView.makeShadow()
        mostExpensiveStaticView.makeShadow()
        latestMealStaticView.makeShadow()
    }
    

    func bindViewModel() {
       
    }
    
    private func progresstimer() {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.dineInProgressBar.progress = DummyData.shared.dineInProgressCalc(meals: DummyData.shared.myMeals)
        }
    }
    
}
