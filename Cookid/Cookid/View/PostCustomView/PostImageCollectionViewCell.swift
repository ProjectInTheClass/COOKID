//
//  PostImageCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PostImageCollectionViewCell: UICollectionViewCell {
    
    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    
    func updateUI(imageURL: URL?) {
        postImage.setImageWithKf(url: imageURL)
    }
}
