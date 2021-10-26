//
//  MyPageHeaderViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import NSObject_Rx

class MyPageHeaderViewController: UIViewController, ViewModelBindable, HasDisposeBag {
    
    // MARK: - UIComponents
    
    let userImage = UIImageView().then {
        $0.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    let userNickname = UILabel().then {
        $0.textAlignment = .left
    }
    
    let userType = UILabel().then {
        $0.textColor = .systemYellow
        $0.textAlignment = .left
    }
    
    let userDetermination = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    let userCookidCount = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
 
    let userDinInCount = UILabel().then {
        
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    let userRecipeCount = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    var viewModel: MyPageViewModel!
    var coordinator: MyPageCoordinator?
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.makeConstraints()
    }
    
    // MARK: - ConfigureUI
    
    func bindViewModel() {
        
        viewModel.output.userInfo
            .withUnretained(self)
            .bind(onNext: { (owner, user) in
                owner.userImage.setImageWithKf(url: user.image)
                owner.userNickname.text = user.nickname
                owner.userType.text = user.userType.rawValue
                owner.userDetermination.text = user.determination
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.dineInCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userDinInCount.text = "🍚  " + String(count)
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.cookidsCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userCookidCount.text = "💸  " + String(count)
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.output.postCount
            .withUnretained(self)
            .bind { (owner, count) in
                owner.userRecipeCount.text = "📝  " + String(count)
            }
            .disposed(by: rx.disposeBag)
        
    }
    
    private func makeConstraints() {
        
        let userNT = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.alignment = .leading
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 5
        }
        
        let userNTD = UIStackView(arrangedSubviews: [userNT, userDetermination]).then {
            $0.alignment = .leading
            $0.distribution = .fillEqually
            $0.axis = .vertical
            $0.spacing = 5
        }
        
        let countSV = UIStackView(arrangedSubviews: [userCookidCount, userDinInCount, userRecipeCount]).then {
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .horizontal
            $0.spacing = 0
        }
        
        let userStackView = UIStackView(arrangedSubviews: [userNTD, countSV]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 15
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [userImage, userStackView]).then {
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 15
        }
        
        self.view.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
