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
    @IBOutlet weak var nextPageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nextPageButton.isHidden = true
    }
    
    func bindViewModel() {
        
        usertypeSegment.rx.value
            .do(onNext: { [weak self] num in
                if num == 0 || num == 1 {
                    self?.nextPageButton.isHidden = false
                } else {
                    self?.nextPageButton.isHidden = true
                }
            })
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
