//
//  ThirdPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit

class ThirdPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    var viewModel: LocalSignInViewModel!
    
    @IBOutlet weak var mealTypeStackView: UIStackView!
    @IBOutlet weak var usertypeSegment: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        mealTypeStackView.alpha = 0
        view.backgroundColor = DefaultStyle.Color.bgTint
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.mealTypeStackView.alpha = 1
        })
    }
    
    func bindViewModel() {
        usertypeSegment.rx.value
            .withUnretained(self)
            .bind { owner, num in
                switch num {
                case 0:
                    owner.viewModel.input.usertype.accept(UserType.preferDineIn)
                case 1:
                    owner.viewModel.input.usertype.accept(UserType.preferDineOut)
                default :
                    break
                }
            }
            .disposed(by: rx.disposeBag)
    }
}
