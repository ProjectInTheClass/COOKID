//
//  MyPostCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Then
import SnapKit

class MyPostCollectionViewCell: UICollectionViewCell, View {
    
    private let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func makeConstraints() {
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func updateUI(post: Post) {
        postImage.image = post.images.first
    }
    
    func bind(reactor: MyPostReactor) {
        reactor.state
            .map { $0.myPost }
            .withUnretained(self)
            .bind { cell, post in
                cell.postImage.image = post.images.first
            }
            .disposed(by: disposeBag)
    }
}
