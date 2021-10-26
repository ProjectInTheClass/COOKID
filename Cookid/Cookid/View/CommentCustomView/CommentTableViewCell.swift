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
        $0.layer.cornerRadius = 25 / 2
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
    
    let reportButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(pointSize: 13)
        $0.setImage(UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .systemGray4
    }
    
    let deleteButton = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(pointSize: 13)
        $0.setImage(UIImage(systemName: "trash.circle.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .systemGray4
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
        
        let userInfoStackView = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 5
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [dateLabel, reportButton, deleteButton]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 10
        }
        
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.width.equalTo(userImage.snp.height).multipliedBy(1)
        }
        
        contentView.addSubview(userInfoStackView)
        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.top).offset(2)
            make.left.equalTo(userImage.snp.right).offset(10)
        }
        
        contentView.addSubview(content)
        contentView.addSubview(buttonStackView)
        
        content.snp.makeConstraints { make in
            make.left.equalTo(userInfoStackView.snp.left)
            make.top.equalTo(userInfoStackView.snp.bottom).offset(3)
            make.right.lessThanOrEqualToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(buttonStackView.snp.top).offset(-10)
        }

        buttonStackView.snp.makeConstraints { make in
            make.left.equalTo(content.snp.left)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(15)
        }
    }
    
    func bind(reactor: CommentCellReactor) {
        let comment = reactor.currentState.comment
        self.userImage.setImageWithKf(url: comment.user.image)
        self.userNickname.text = comment.user.nickname
        self.userType.text = comment.user.userType.rawValue
        self.content.text = comment.content
        self.dateLabel.text = convertDateToString(format: "MM월 dd일", date: comment.timestamp)
        
        reactor.state.map { $0.user }
        .withUnretained(self)
        .bind { owner, user in
            if comment.user.id == user.id {
                owner.reportButton.isHidden = true
                owner.deleteButton.isHidden = false
            } else {
                owner.reportButton.isHidden = false
                owner.deleteButton.isHidden = true
            }
        }
        .disposed(by: disposeBag)
    }
}
