//
//  RankingTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/14.
//

import UIKit
import SnapKit
import Then

class RankingTableViewCell: UITableViewCell {
    
    private let cellBackgroundView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 15
    }
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    private let userName = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        $0.textColor = .systemIndigo
    }
    
    private let userDetermine = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    
    let recordImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "Cookid")
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let cookidCount = UILabel().then {
        $0.text = "100"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    private let rankingLabel = UILabel().then {
        $0.text = "1"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        let userNameType = UIStackView(arrangedSubviews: [userName, userType])
        userNameType.distribution = .fill
        userNameType.alignment = .fill
        userNameType.axis = .horizontal
        userNameType.spacing = 5
        
        let userLabelStack = UIStackView(arrangedSubviews: [userNameType, userDetermine])
        userLabelStack.distribution = .fillEqually
        userLabelStack.alignment = .leading
        userLabelStack.axis = .vertical
        userLabelStack.spacing = 2
        
        let dineInStack = UIStackView(arrangedSubviews: [recordImage, cookidCount])
        dineInStack.distribution = .fill
        dineInStack.alignment = .fill
        dineInStack.axis = .horizontal
        dineInStack.spacing = 5
        
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(7)
            make.left.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-7)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(70)
        }
        
        cellBackgroundView.addSubview(dineInStack)
        dineInStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(cellBackgroundView).offset(-30)
        }
        
        cellBackgroundView.addSubview(rankingLabel)
        rankingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        cellBackgroundView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(rankingLabel.snp.right).offset(10)
            make.width.height.equalTo(40)
        }
        
        cellBackgroundView.addSubview(userLabelStack)
        userLabelStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(userImage.snp.right).offset(10)
        }
        
        contentView.backgroundColor = .systemBackground
        
    }
    
    public func updateUI(user: User, ranking: Int) {
        rankingLabel.text = String(describing: ranking + 1)
        userName.text = user.nickname
        userType.text = "#" + user.userType.rawValue
        userDetermine.text = user.determination
        // 추후에 업데이트
        cookidCount.text = "\(user.cookidsCount)"
        userImage.setImageWithKf(url: user.image)
    }
}
