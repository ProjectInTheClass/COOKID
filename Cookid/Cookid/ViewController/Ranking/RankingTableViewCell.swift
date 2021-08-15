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
    
    private let userImage = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 40)
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
        
        let userInfoStack = UIStackView(arrangedSubviews: [userImage, userLabelStack])
        userInfoStack.distribution = .fill
        userInfoStack.alignment = .fill
        userInfoStack.axis = .horizontal
        userInfoStack.spacing = 8
        
        let dineInStack = UIStackView(arrangedSubviews: [dineInImage, dineInCount])
        dineInStack.distribution = .fillProportionally
        dineInStack.alignment = .center
        dineInStack.axis = .horizontal
        dineInStack.spacing = 5
        
        contentView.addSubview(userInfoStack)
        contentView.addSubview(dineInStack)

        userInfoStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.left.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        dineInStack.snp.makeConstraints { make in
            make.centerY.equalTo(userInfoStack)
            make.right.equalTo(contentView).offset(-25)
        }
    }
    
    public func updateUI(user: UserForRanking) {
        
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
