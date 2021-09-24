//
//  PostHeaderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class PostHeaderView: UIView {
    
    private let imagebackgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.makeCircleView()
        $0.clipsToBounds = true
    }
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.makeCircleView()
    }
    
    private let caption = UILabel().then {
        $0.text = "추천할 만한 맛있는 식사를 하셨나요?\n소중한 후기를 공유하고 🥇 랭커가 되어주세요!"
        $0.numberOfLines = 0
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.textColor = .darkGray
    }
    
    let captionButton = UIButton().then {
        $0.setTitle("📄 글 올리기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 8
    }
    
    let cameraButton = UIButton().then {
        $0.setTitle("📷 사진 올리기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 8
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func updateUI(user: User) {
        userImage.kf.setImage(with: user.image, placeholder: UIImage(named: IMAGENAME.placeholder))
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        imagebackgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        imagebackgroundView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.centerY.equalTo(imagebackgroundView)
        }
        
        let userInfoStackView = UIStackView(arrangedSubviews: [imagebackgroundView, caption]).then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 15
            $0.axis = .horizontal
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [captionButton, cameraButton]).then {
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 10
            $0.axis = .horizontal
        }
        
        self.addSubview(userInfoStackView)
        userInfoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        self.addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
    }
}
