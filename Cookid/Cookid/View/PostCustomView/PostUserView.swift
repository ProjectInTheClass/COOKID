//
//  PostUserView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import Then
import SnapKit

class PostUserView: UIView {
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.makeCircleView()
    }
    
    private let userNickname = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textAlignment = .left
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textAlignment = .left
        $0.textColor = .systemYellow
    }
    
    private let location = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .light)
        $0.textAlignment = .left
    }
    
    let reportingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "archivebox"), for: .normal)
        $0.tintColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateUI(post: Post) {
        userImage.setImageWithKf(url: post.user.image)
        userType.text = post.user.userType.rawValue
        userNickname.text = post.user.nickname
        location.text = "📮 " + post.location
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(35)
        }
        
        self.addSubview(userType)
        userType.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(userNickname)
        userNickname.snp.makeConstraints { make in
            make.left.equalTo(userType.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(location)
        location.snp.makeConstraints { make in
            make.left.equalTo(userNickname.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        
        self.addSubview(reportingButton)
        reportingButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }

    }
}
