//
//  MyPostTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/08.
//

import UIKit
import Then
import SnapKit

class MyPostTableViewCell: UITableViewCell {

    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
