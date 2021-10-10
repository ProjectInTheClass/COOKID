//
//  MyPostCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import Kingfisher

class MyPostCollectionViewCell: UICollectionViewCell {
    
    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    private func makeConstraints() {
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func updateUI(post: Post) {
        guard let postFirstImageUrl = post.images.first else { return }
        postImage.setImageWithKf(url: postFirstImageUrl)
    }
    
}
