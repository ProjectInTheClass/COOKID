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
    
    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(image: UIImage?) {
        postImage.image = image
    }
    
}
