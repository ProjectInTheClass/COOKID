//
//  PictureSelectCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/26.
//

import UIKit
import SnapKit
import Then

class PictureSelectCollectionViewCell: UICollectionViewCell {
    
    private let menuImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.makeCircleView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .systemBackground
        self.contentView.addSubview(menuImage)
        menuImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(menu: Menu) {
        menuImage.image = menu.image
    }
    
}
