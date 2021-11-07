//
//  UserPhotoEditButton.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/07.
//

import Foundation

import UIKit
import SnapKit
import Then

class UserPhotoEditButton: UIView {
    
    public var circleColor: UIColor = .label {
        didSet {
            self.backgroundColor = circleColor
        }
    }
    
    public var userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray6
        $0.tintColor = .systemGray4
        let config = UIImage.SymbolConfiguration.init(pointSize: 17)
        $0.image = UIImage(systemName: "person.fill", withConfiguration: config)
    }
    
    public let cameraButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemBackground
        $0.tintColor = DefaultStyle.Color.labelTint
        let config = UIImage.SymbolConfiguration.init(pointSize: 23)
        $0.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func backgroundSetting() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = self.frame.height / 2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.layer.masksToBounds = true
        
        cameraButton.layer.cornerRadius = cameraButton.frame.height / 2
        cameraButton.layer.masksToBounds = true
    }
    
    private func configureUI() {
        self.backgroundColor = circleColor
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().multipliedBy(0.94)
            make.centerX.centerY.equalToSuperview()
        }
        
        self.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.30)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundSetting()
    }
    
}
