//
//  MyPostTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import Then
import SnapKit

class MyPostTableViewCell: UITableViewCell {

    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let postRegionLabel = UILabel().then {
        $0.textColor = .label
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postDateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    private let starSlider = StarSlider()
    
    private let postHeartLabel = UILabel().then {
        $0.text = "좋아요"
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postHeartCount = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postBookmarkLabel = UILabel().then {
        $0.text = "북마크"
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    private let postBookmarkCount = UILabel()
    
    private let postCommentLabel = UILabel().then {
        $0.text = "댓글"
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    private let postCommentCount = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    private func makeConstraints() {
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.width.equalTo(postImage.snp.height)
        }
        
        contentView.addSubview(postRegionLabel)
        postRegionLabel.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.top)
            make.left.equalTo(postImage.snp.right).offset(10)
        }
        
        contentView.addSubview(postContentLabel)
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postRegionLabel.snp.bottom).offset(10)
            make.left.equalTo(postRegionLabel)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        contentView.addSubview(postDateLabel)
        postDateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(postImage.snp.bottom)
            make.left.equalTo(postImage.snp.right).offset(10)
        }
        
        contentView.addSubview(postHeartLabel)
        postHeartLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postDateLabel.snp.centerY)
            make.left.equalTo(postDateLabel.snp.right).offset(10)
        }
        
        contentView.addSubview(postHeartCount)
        postHeartCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postHeartLabel.snp.right).offset(5)
        }
        
        contentView.addSubview(postBookmarkLabel)
        postBookmarkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postHeartCount.snp.right).offset(10)
        }
        
        contentView.addSubview(postBookmarkCount)
        postBookmarkCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postBookmarkLabel.snp.right).offset(5)
        }
        
        contentView.addSubview(postCommentLabel)
        postCommentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postBookmarkCount.snp.right).offset(10)
        }
        
        contentView.addSubview(postCommentCount)
        postCommentCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postCommentLabel.snp.right).offset(5)
        }
    
    }
    
    func updateUI(post: Post) {
        guard let postFirstImageUrl = post.images.first else { return }
        postImage.setImageWithKf(url: postFirstImageUrl)
        postCommentCount.text = "\(post.commentCount)개"
        postHeartCount.text = "\(post.likes)개"
        postBookmarkCount.text = "\(post.collections)개"
        postContentLabel.text = post.caption
        postDateLabel.text = convertDateToString(format: "MM월 dd일", date: post.timeStamp)
    }

}
