//
//  CommentTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import Kingfisher

class CommentTableViewCell: UITableViewCell, View {
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 35 / 2
        $0.layer.masksToBounds = true
    }
    
    private let userNickname = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemYellow
    }
    
    private let content = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let reportButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil.tip.crop.circle"), for: .normal)
        $0.tintColor = .gray
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        $0.tintColor = .gray
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
    }
    
    private let subCommentButton = UIButton().then {
        $0.setTitleColor(.gray, for: .normal)
        $0.setTitle("답글 달기", for: .normal)
        $0.snp.makeConstraints { make in
            make.height.equalTo(15)
        }
    }
    
    var disposeBag: DisposeBag =  DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
        
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.height.equalTo(35)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.width.equalTo(userImage.snp.height).multipliedBy(1)
        }
        
        let userInfoStackView = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 5
        }
        
        contentView.addSubview(userInfoStackView)
        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.top).offset(2)
            make.left.equalTo(userImage.snp.right).offset(10)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.left.equalTo(userInfoStackView.snp.left)
            make.top.equalTo(userInfoStackView.snp.bottom)
            make.bottom.greaterThanOrEqualToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [subCommentButton, reportButton, deleteButton]).then {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 10
        }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func bind(reactor: CommentCellReactor) {
        let comment = reactor.currentState.comment
        self.userImage.setImageWithKf(url: comment.user.image)
        self.userNickname.text = comment.user.nickname
        self.userType.text = comment.user.userType.rawValue
        self.content.text = comment.content
        
        if comment.user.id == reactor.currentState.user.id {
            self.reportButton.isHidden = true
            self.deleteButton.isHidden = false
        } else {
            self.reportButton.isHidden = false
            self.deleteButton.isHidden = true
        }
        
        reportButton.rx.tap
            .map { Reactor.Action.report }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map { Reactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        subCommentButton.rx.tap
            .map { Reactor.Action.reply }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
  
    
}
