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
    
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        $0.tintColor = .systemGray6
        $0.addTarget(self, action: #selector(navigateYPImagePicker), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.right.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func navigateYPImagePicker() {
        print("navigateYPImagePicker")
    }
}
