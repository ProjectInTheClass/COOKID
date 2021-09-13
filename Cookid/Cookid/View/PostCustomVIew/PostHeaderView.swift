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
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.makeCircleView()
    }
    
    private let toplineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private let bottomlineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private let caption = UILabel().then {
        $0.text = "추천할 만한 식사를 하셨나요?\n소중한 후기를 공유하고 🥇 랭커가 되어주세요!"
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.textColor = .systemGray3
    }
    
    private let cameraButton = UIButton().then {
        $0.setTitle("📷 사진 올리기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.makeConstraints()
    }
    
    func updateUI(user: User) {
        userImage.kf.setImage(with: user.image, placeholder: UIImage(named: IMAGENAME.placeholder))
    }
    
    private func makeConstraints() {
        
        self.addSubview(toplineView)
        toplineView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(5)
            make.right.top.left.equalToSuperview()
        }
    
        self.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(bottomlineView)
        bottomlineView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(5)
            make.right.bottom.left.equalToSuperview()
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [caption, cameraButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 0
        buttonStackView.alignment = .fill
        
        self.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
