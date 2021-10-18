//
//  CommentInputTextField.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/17.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class CommentInputTextField: UIView, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let uploadButton = CookidButton().then {
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        $0.imageView?.contentMode = .scaleAspectFill
        $0.tintColor = .darkGray
        $0.buttonImage = image
    }
    
    lazy var commentTextField = UITextField().then {
        $0.borderStyle = .none
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        $0.leftViewMode = .always
        $0.rightView = uploadButton
        $0.rightViewMode = .whileEditing
        $0.backgroundColor = .systemGray6
        $0.placeholder = "댓글 쓰기..."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
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
        self.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.width.equalTo(userImage.snp.height).multipliedBy(1)
        }
        
        self.addSubview(commentTextField)
        commentTextField.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.backgroundColor = .systemBackground
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 15
    }
    
    func bind(reactor: CommentReactor) {
        
        reactor.state.map { $0.user }
        .withUnretained(self)
        .bind(onNext: { owner, user in
            owner.userImage.setImageWithKf(url: user.image)
        })
        .disposed(by: disposeBag)
        
        commentTextField.rx.text.orEmpty
            .map { Reactor.Action.commentContent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .take(1)
            .map { Reactor.Action.addComment }
            .do(onNext: { [unowned self] _ in
                self.commentTextField.resignFirstResponder()
                self.commentTextField.text = ""
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

}
