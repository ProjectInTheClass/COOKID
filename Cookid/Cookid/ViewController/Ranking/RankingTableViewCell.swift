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
    
    private let userImage = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 35)
    }
    private let userName = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        $0.textColor = .systemYellow
    }
    
    private let userDetermine = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    private let dineInImage = UILabel().then {
        $0.text = "🍚"
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
    }
    
    private let dineInCount = UILabel().then {
        $0.text = "100"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 15, weight: .black)
    }
    
    private let rankingLabel = UILabel().then {
        $0.text = "100"
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
        userNameType.spacing = 8
        
        let userLabelStack = UIStackView(arrangedSubviews: [userNameType, userDetermine])
        userLabelStack.distribution = .fillEqually
        userLabelStack.alignment = .leading
        userLabelStack.axis = .vertical
        userLabelStack.spacing = -5
        
        let userInfoStack = UIStackView(arrangedSubviews: [rankingLabel, userImage, userLabelStack])
        userInfoStack.distribution = .fill
        userInfoStack.alignment = .fill
        userInfoStack.axis = .horizontal
        userInfoStack.spacing = 10
        
        let dineInStack = UIStackView(arrangedSubviews: [dineInImage, dineInCount])
        dineInStack.distribution = .fillProportionally
        dineInStack.alignment = .center
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
        
        cellBackgroundView.addSubview(userInfoStack)
        cellBackgroundView.addSubview(dineInStack)
        
        userInfoStack.snp.makeConstraints { make in
            make.top.equalTo(cellBackgroundView).offset(10)
            make.left.equalTo(cellBackgroundView).offset(20)
            make.bottom.equalTo(cellBackgroundView).offset(-10)
        }
        
        dineInStack.snp.makeConstraints { make in
            make.centerY.equalTo(userInfoStack)
            make.right.equalTo(cellBackgroundView).offset(-30)
        }
        
        contentView.backgroundColor = .systemBackground
        
    }
    
    public func updateUI(user: UserForRanking, ranking: Int) {
        rankingLabel.text = String(describing: ranking + 1)
        userName.text = user.nickname
        userType.text = "#" + user.userType.rawValue
        userDetermine.text = user.determination
        // 추후에 업데이트
        dineInCount.text = "\(user.groceryMealSum)"
        
        switch user.userType {
        case .preferDineIn:
            userImage.text = "🍚"
        case .preferDineOut:
            userImage.text = "🍟"
        }
    }
}
