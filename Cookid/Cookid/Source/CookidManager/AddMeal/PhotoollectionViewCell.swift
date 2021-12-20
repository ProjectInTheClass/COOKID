//
//  PhotoollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/12/20.
//

import UIKit
import SnapKit
import Then

class PhotoollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoollectionViewCell"
    
    private let photo = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("error", file: #file, line: #line)
    }
    
    private func makeConstraints() {
        contentView.addSubview(photo)
        photo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
