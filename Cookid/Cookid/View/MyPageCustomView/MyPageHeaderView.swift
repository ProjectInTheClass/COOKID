//
//  MyPageHeaderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/06.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MyPageHeaderView: UIView {
    
    // MARK: - UIComponents
    
    let user: User
    
    lazy var userImage = UIImageView().then {
        $0.kf.setImage(with: user.image, placeholder: UIImage(named: "placeholder"))
    }
    
    lazy var userNickname = UILabel().then {
        $0.text = user.nickname
    }
    
    lazy var userType = UILabel().then {
        $0.text = "#" + user.userType.rawValue
    }
    
    lazy var userDetermination = UILabel().then {
        $0.text = user.determination
    }
    
    lazy var userCookidCount = UILabel().then {
        $0.text = String(describing: user.cookidsCount)
    }
    
    lazy var userDinInCount = UILabel().then {
        $0.text = String(describing: user.dineInCount)
    }
    
    lazy var settingImage = UIButton().then {
        $0.tintColor = .darkGray
        $0.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
    }
    
    // MARK: - Initializer
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        self.makeConstraints()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        self.makeShadow()
    }
    
    private func makeConstraints() {
        
        let userNT = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 10
            $0.backgroundColor = .blue
        }
        
        let userNTD = UIStackView(arrangedSubviews: [userNT, userDetermination]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 10
            $0.backgroundColor = .red
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [userImage, userNTD, settingImage]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = 10
            $0.backgroundColor = .yellow
        }
        
        self.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
    }
    
}
