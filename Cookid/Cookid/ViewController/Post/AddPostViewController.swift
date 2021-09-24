//
//  AddPostViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import SnapKit
import Then
import NSObject_Rx

class AddPostViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // UIComponent
    
    @IBOutlet weak var postImageView: PostImageView!
    @IBOutlet weak var uploadPostButton: UIButton!
    
    var viewModel: PostViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "포스트 작성"
    }
    
    func bindViewModel() {
        
        uploadPostButton.rx.tap
            .bind(onNext: {
                print("uploadPostButton tapped")
            })
            .disposed(by: rx.disposeBag)
        
    }
    
}
