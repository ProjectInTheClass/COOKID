//
//  MyPageHeaderTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import SnapKit
import Then

final class MyPageHeaderTableViewCell: UITableViewCell {
    
    private let cellBackgroundView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 15
    }
    
    private let noticeTitle = UILabel().then {
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(7)
            make.left.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-7)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(55)
        }
        
        cellBackgroundView.addSubview(noticeTitle)
        noticeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
    }
    
    func updateUI(title: String) {
        noticeTitle.text = title
    }
    
}
