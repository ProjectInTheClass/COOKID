//
//  PanModalHeaderView.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/13.
//
import UIKit

class PanModalHeaderView: UIView {
    
    //    let completionHandler : (() -> Void)?
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    }
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "쇼핑 기록"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
        label.font = .systemFont(ofSize: 13)
        label.text = "오늘은 얼마를 사용하셨나요?"
        return label
    }()
    
    var rightBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.snp.makeConstraints{
            $0.width.height.equalTo(40)
        }
        btn.addTarget(self, action: #selector(completion), for: .touchUpInside)
        return btn
    }()
    
    @objc func completion () {
        completion()
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1).withAlphaComponent(0.11)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        addSubview(stackView)
        addSubview(seperatorView)
        addSubview(rightBtn)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func setupConstraints() {
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInsets.bottom).isActive = true
        
        seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        rightBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-10)
        }
        rightBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - View Configuration
    
    //    func configure(with presentable: UserGroupHeaderPresentable) {
    //        titleLabel.text = "@\(presentable.handle)"
    //        subtitleLabel.text = "\(presentable.memberCount) members  |  \(presentable.description)"
    //    }
    
}
