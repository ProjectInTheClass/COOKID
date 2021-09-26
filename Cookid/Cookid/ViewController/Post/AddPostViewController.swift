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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPostImageCV" {
            guard var cv = segue.destination as? AddPostImageCollectionViewController else { return }
            cv.bind(viewModel: viewModel)
        }
    }
    
}
