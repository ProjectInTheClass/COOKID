//
//  PhotoollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private let photo = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .systemGray6
    }
    
    private func makeConstraints() {
        contentView.addSubview(photo)
        photo.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension PhotoCollectionViewCell {
    func rendering(photo: Photo) {
        self.photo.kf.setImage(with: photo.image.url)
    }
}
