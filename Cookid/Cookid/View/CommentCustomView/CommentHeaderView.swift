//
//  CommentHeaderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/16.
//

import UIKit
import SnapKit
import Then

class CommentHeaderView: UIView {
    
    let postImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let postUserImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let postUserNickname = UILabel().then {
        $0.textAlignment = .natural
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    }
    
    let postDate = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        $0.textColor = .systemGray
    }
    
    let captionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        self.backgroundColor = .systemBackground
    }
    
    private func makeConstraints() {
        
        self.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.width.height.equalTo(80)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
        
        self.addSubview(postUserImageView)
        postUserImageView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.top)
            make.left.equalTo(postImageView.snp.right).offset(15)
            make.height.equalTo(postImageView.snp.height).multipliedBy(0.33)
            make.width.equalTo(postUserImageView.snp.height).multipliedBy(1)
        }
        
        self.addSubview(postUserNickname)
        postUserNickname.snp.makeConstraints { make in
            make.centerY.equalTo(postUserImageView.snp.centerY)
            make.left.equalTo(postUserImageView.snp.right).offset(5)
        }
        
        self.addSubview(postDate)
        self.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(postUserImageView.snp.bottom).offset(7)
            make.left.equalTo(postUserImageView.snp.left).offset(2)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            make.bottom.lessThanOrEqualTo(postDate.snp.top).offset(-7)
        }
        
        postDate.snp.makeConstraints { make in
            make.left.equalTo(postUserImageView.snp.left)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.layer.cornerRadius = 15
        postImageView.layer.masksToBounds = true
        postUserImageView.layer.cornerRadius = postUserImageView.frame.height / 2
        postUserImageView.layer.masksToBounds = true
    }
    
    func updateUI(post: Post) {
        postImageView.setImageWithKf(url: post.images.first!)
        postUserImageView.setImageWithKf(url: post.user.image)
        postUserNickname.text = post.user.nickname
        captionLabel.text = post.caption
        postDate.text = convertDateToString(format: "yy년 MM월 dd일", date: post.timeStamp)
    }
}
