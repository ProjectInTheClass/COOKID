//
//  ThirdPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class ThirdPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: OnboardingViewModel!
    
    @IBOutlet weak var usertypeSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func bindViewModel() {
        
        usertypeSegment.rx.value
            .bind { [weak self] num in
                switch num {
                case 0:
                    self?.viewModel.input.usertype.onNext(UserType.preferDineIn)
                case 1:
                    self?.viewModel.input.usertype.onNext(UserType.preferDineOut)
                default :
                    break
                }
            }
            .disposed(by: rx.disposeBag)
        
    }


}
