//
//  MyPageViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SnapKit
import Then

class MyPageViewController: UIViewController, ViewModelBindable, StoryboardBased {
    
    // MARK: - UIComponents
    
    @IBOutlet weak var userInfo: MyPageHeaderView!
    
    
    // MARK: - Properties
    
    var viewModel: MyPageViewModel!
    var coordinator : HomeCoordinator?
    
    // MARK: - View LifeCycle and Fuctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "내 정보📙"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
    }
    
    @objc func settingButtonTapped() {
        coordinator?.navigateUserInfoVC(viewModel: viewModel)
    }
    
    // MARK: - BindViewMdoel
    func bindViewModel() {
        viewModel.output.userInfo
            .bind { [unowned self] (user) in
                self.userInfo.updateUI(user: user)
            }
            .disposed(by: rx.disposeBag)
    }
    
}
