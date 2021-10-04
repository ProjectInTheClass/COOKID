//
//  MyMealsCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/08.
//

import UIKit
import SnapKit
import Then

class MyMealsCollectionViewCell: UICollectionViewCell {
    static let identifire = "MyCollectionViewCell"
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.clipsToBounds = true
    }
    
    func updateUI(image: UIImage?) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
}
