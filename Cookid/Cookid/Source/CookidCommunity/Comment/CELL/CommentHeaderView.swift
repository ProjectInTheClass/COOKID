//
//  CommentHeaderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/27.
//

import UIKit
import Then
import SnapKit
import NSObject_Rx
import RxSwift
import RxCocoa

class CommentHeaderView: UIView {
    
    private let userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemYellow
    }
    
    private let userNickname = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    
    private let caption = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let heartLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let bookmarkLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let locationLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let starLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let underbarView = UIView().then {
        $0.backgroundColor = .systemGray6
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        let userInfoStackView = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 5
        }
        
        self.addSubview(userImageView)
        self.addSubview(caption)
        self.addSubview(userInfoStackView)
        self.addSubview(dateLabel)
        self.addSubview(heartLabel)
        self.addSubview(bookmarkLabel)
        self.addSubview(underbarView)
        self.addSubview(locationLabel)
        self.addSubview(starLabel)

        userImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.width.height.equalTo(35)
        }

        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top).offset(2)
            make.left.equalTo(userImageView.snp.right).offset(10)
        }

        caption.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.bottom).offset(3)
            make.left.equalTo(userInfoStackView.snp.left)
            make.right.equalToSuperview().offset(-10)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(caption.snp.bottom).offset(5)
            make.left.equalTo(caption.snp.left)
        }
        
        starLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationLabel.snp.centerY)
            make.left.equalTo(locationLabel.snp.right)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(caption.snp.left)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        heartLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.left.equalTo(dateLabel.snp.right).offset(8)
        }
        
        bookmarkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.left.equalTo(heartLabel.snp.right).offset(8)
        }
        
        underbarView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.layer.masksToBounds = true
        self.backgroundColor = .systemBackground
    }
    
    func updateUI(_ post: Post) {
        userImageView.setImageWithKf(url: post.user.image)
        userType.text = post.user.userType.rawValue
        userNickname.text = post.user.nickname
        caption.text = post.caption
        heartLabel.text = "좋아요 \(post.likes)개"
        bookmarkLabel.text = "북마크 \(post.collections)개"
        dateLabel.text = convertDateToString(format: "MM월 dd일", date: post.timeStamp)
        locationLabel.text = "#\(post.location)"
        starLabel.text = "#별점\(post.star)점"
    }
    
}
