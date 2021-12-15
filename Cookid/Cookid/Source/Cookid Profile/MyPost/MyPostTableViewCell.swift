//
//  MyPostTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

class MyPostTableViewCell: UITableViewCell, View {

    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let postRegionLabel = UILabel().then {
        $0.textColor = .label
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let postDateLabel = UILabel().then {
        $0.textColor = .label
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private let postContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let postStarCount = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postPriceLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
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
    private let postBookmarkCount = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let postCommentLabel = UILabel().then {
        $0.text = "댓글"
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    private let postCommentCount = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "text.alignright"), for: .normal)
        $0.tintColor = .systemGray
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
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
        contentView.addSubview(postRegionLabel)
        contentView.addSubview(postContentLabel)
        contentView.addSubview(postDateLabel)
        contentView.addSubview(postHeartLabel)
        contentView.addSubview(postHeartCount)
        contentView.addSubview(postBookmarkLabel)
        contentView.addSubview(postBookmarkCount)
        contentView.addSubview(postCommentLabel)
        contentView.addSubview(postCommentCount)
        contentView.addSubview(postPriceLabel)
        contentView.addSubview(postStarCount)
        contentView.addSubview(settingButton)
        
        postImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.width.equalTo(postImage.snp.height)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.top)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        postRegionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postDateLabel.snp.centerY)
            make.left.equalTo(postDateLabel.snp.right).offset(5)
        }
        
        postDateLabel.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.top).offset(5)
            make.left.equalTo(postImage.snp.right).offset(10)
        }
        
        postContentLabel.snp.makeConstraints { make in
            make.top.equalTo(postDateLabel.snp.bottom).offset(10)
            make.left.equalTo(postDateLabel)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.lessThanOrEqualTo(postPriceLabel.snp.top).offset(-10)
        }
        
        postPriceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(postHeartLabel.snp.top).offset(-5)
            make.left.equalTo(postImage.snp.right).offset(10)
        }
        
        postStarCount.snp.makeConstraints { make in
            make.centerY.equalTo(postPriceLabel.snp.centerY)
            make.left.equalTo(postPriceLabel.snp.right).offset(5)
        }
        
        postHeartLabel.snp.makeConstraints { make in
            make.bottom.equalTo(postImage.snp.bottom).offset(-5)
            make.left.equalTo(postImage.snp.right).offset(10)
        }
        
        postHeartCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postHeartLabel.snp.right).offset(5)
        }
        
        postBookmarkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postHeartCount.snp.right).offset(10)
        }
        
        postBookmarkCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postBookmarkLabel.snp.right).offset(5)
        }
        
        postCommentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postBookmarkCount.snp.right).offset(10)
        }
        
        postCommentCount.snp.makeConstraints { make in
            make.centerY.equalTo(postHeartLabel.snp.centerY)
            make.left.equalTo(postCommentLabel.snp.right).offset(5)
        }
    
    }
    
    func bind(reactor: MyPostTableViewCellReactor) {
        updateUI(post: reactor.currentState.post)
    }
    
    func updateUI(post: Post) {
        if let postFirstImageUrl = post.images.first {
            postImage.setImageWithKf(url: postFirstImageUrl)
        }
        postImage.makeShadow()
        postCommentCount.text = "\(post.commentCount)개"
        postHeartCount.text = "\(post.likes)개"
        postBookmarkCount.text = "\(post.collections)개"
        postContentLabel.text = post.caption
        postDateLabel.text = convertDateToString(format: "MM월 dd일", date: post.timeStamp)
        postRegionLabel.text = post.location
        postPriceLabel.text = "#\(intToString(post.mealBudget))"
        postStarCount.text = "#별점\(post.star)점"
    }

}
