//
//  AddPostImageCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/24.
//

import UIKit
import SnapKit
import Then

class AddPostImageCollectionViewCell: UICollectionViewCell {
    
    let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    let cancelButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        $0.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .systemGray4
        $0.alpha = 0.9
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(image: UIImage?) {
        postImage.image = image
    }
    
}
