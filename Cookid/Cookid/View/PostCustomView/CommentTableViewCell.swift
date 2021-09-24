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
        $0.makeCircleView()
    }
    
    private let userNickname = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let userType = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemYellow
    }
    
    private let content = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
    }
    
    private let updateButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil.tip.crop.circle"), for: .normal)
        $0.tintColor = .gray
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        $0.tintColor = .gray
    }
    
    var disposeBag: DisposeBag =  DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(userImage.snp.height).multipliedBy(1/1)
        }
        
        let userInfoStackView = UIStackView(arrangedSubviews: [userType, userNickname]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.spacing = 5
        }
        
        contentView.addSubview(userInfoStackView)
        userInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.top)
            make.left.equalTo(userImage.snp.right).offset(5)
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.left.equalTo(userInfoStackView.snp.left)
            make.top.equalTo(userInfoStackView.snp.bottom).offset(5)
            make.bottom.right.equalToSuperview().offset(-5)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [updateButton, deleteButton]).then {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 5
        }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(userInfoStackView.snp.top)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(content.snp.top).offset(5)
        }
    }
    
    func bind(reactor: CommentReactor) {
        reactor.state.map { $0.comment }
        .bind { [unowned self] comment in
            self.userImage.kf.setImage(with: comment.user.image, placeholder: UIImage(systemName: "person.circil.fill"), options: .none, completionHandler: nil)
            self.userNickname.text = comment.user.nickname
            self.userType.text = comment.user.userType.rawValue
            self.content.text = comment.content
        }
        .disposed(by: disposeBag)
    }
    
}
