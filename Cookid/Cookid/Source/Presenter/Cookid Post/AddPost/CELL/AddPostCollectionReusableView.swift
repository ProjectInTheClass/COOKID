//
//  AddPostCollectionReusableView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import UIKit
import SnapKit
import Then

class AddPostCollectionReusableView: UICollectionReusableView {
    
    let plusButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .default)
        $0.setImage(UIImage(systemName: "plus.app.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .systemGray6
    }
    
    let noticeLabel = UILabel().then {
        $0.text = "이미지는 3장까지 선택하실 수 있어요:)"
        $0.textColor = .systemGray2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        self.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(plusButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
