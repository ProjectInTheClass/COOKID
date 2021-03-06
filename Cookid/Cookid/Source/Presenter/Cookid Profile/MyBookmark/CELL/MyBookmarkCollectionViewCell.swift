//
//  MyBookmarkCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/05.
//

import UIKit
import ReactorKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MyBookmarkCollectionViewCell: UICollectionViewCell, View {
    
    let postImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let dateLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    let regionLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 17, weight: .black)
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    let priceLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.shadowColor = .black
        $0.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    let heartButton = HeartButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
        let heartImage = UIImage(systemName: "heart", withConfiguration: config)
        $0.imageView?.contentMode = .scaleToFill
        $0.setImage(heartImage, for: .normal)
    }
    
    let bookmarkButton = BookmarkButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
        let bookmarkImage = UIImage(systemName: "bookmark", withConfiguration: config)
        $0.imageView?.contentMode = .scaleToFill
        $0.setImage(bookmarkImage, for: .normal)
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
        }

        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(8)
            make.right.equalTo(contentView.snp.right).offset(-8)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
        }

        contentView.addSubview(regionLabel)
        regionLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(8)
            make.right.equalTo(contentView.snp.right).offset(-8)
            make.bottom.equalTo(priceLabel.snp.top).offset(-1)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(8)
            make.right.equalTo(contentView.snp.right).offset(-8)
            make.bottom.equalTo(regionLabel.snp.top).offset(-2)
        }

        contentView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
            make.width.height.equalTo(25)
        }
        
        contentView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.bottom).offset(5)
            make.right.equalTo(contentView.snp.right).offset(-5)
            make.width.height.equalTo(25)
        }

    }
    
    func bind(reactor: PostCellReactor) {
        
        if let url = reactor.post.images.first {
            self.postImage.setImageWithKf(url: url)
        }
        self.heartButton.setState(reactor.post.didLike)
        self.dateLabel.text = reactor.post.timeStamp.convertDateToString(format: "MM월 dd일")
        self.priceLabel.text = intToString(reactor.post.mealBudget)
        self.regionLabel.text = reactor.post.location
        
        reactor.state.map { $0.isHeart }
        .withUnretained(self)
        .bind { owner, isHeart in
            owner.heartButton.setState(isHeart)
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isBookmark }
        .withUnretained(self)
        .bind { owner, isBookmark in
            owner.bookmarkButton.setState(isBookmark)
        }
        .disposed(by: disposeBag)
        
        heartButton.rx.tap
            .map { Reactor.Action.heartbuttonTapped(self.heartButton.isActivated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .map { Reactor.Action.bookmarkButtonTapped(self.bookmarkButton.isActivated)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
    }

}
