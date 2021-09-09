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
    
    let userImage = UIImageView().then {
        $0.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
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
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeConstraints()
//        self.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.makeConstraints()
//        self.backgroundColor = .systemRed
    }
    
    // MARK: - ConfigureUI
    
    func updateUI(user: User) {
        userImage.kf.setImage(with: user.image, placeholder: UIImage(named: "placeholder"))
        userNickname.text = user.nickname
        userType.text = user.userType.rawValue
        userDetermination.text = user.determination
        userCookidCount.text = "💸  " + String(describing: user.cookidsCount ?? 0)
        userDinInCount.text = "🍚  " + String(describing: user.dineInCount ?? 0)
        userRecipeCount.text = "📝  " + "0"
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
        
        self.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview()
        }
        
    }
    
}
