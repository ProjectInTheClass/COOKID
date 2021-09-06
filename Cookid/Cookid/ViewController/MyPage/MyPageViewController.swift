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

class MyPageViewController: UIViewController, ViewModelBindable {
    
    // MARK: - UIComponents
    
    private let userView = MyPageHeaderView(user: DummyData.shared.singleUser)
    
    // MARK: - Properties
    var viewModel: MyPageViewModel!
    var coordinator : HomeCoordinator?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBarItem.image = UIImage(systemName: "person.crop.circle")
        tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        navigationItem.title = "내 정보📙"
    }
    
    private func makeConstraints() {
        view.addSubview(userView)
        userView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(400)
        }
    }
    
    // MARK: - BindViewMdoel
    func bindViewModel() {
        viewModel.output.userInfo
            .bind { [unowned self] (user) in
                
            }
            .disposed(by: rx.disposeBag)
    }
}
