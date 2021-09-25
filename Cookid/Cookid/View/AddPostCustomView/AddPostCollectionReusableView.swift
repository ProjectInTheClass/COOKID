//
//  AddPostCollectionReusableView.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import UIKit
import SnapKit
import Then
import YPImagePicker

class AddPostCollectionReusableView: UICollectionReusableView {
    
    let plusButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .default)
        $0.setImage(UIImage(systemName: "plus.app.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .systemGray6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
