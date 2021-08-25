////
////  PanModalHeaderView.swift
////  Cookid
////
////  Created by Sh Hong on 2021/07/13.
////
//import UIKit
//
//class PanModalHeaderView: UIView {
//    
//    let contentInsets = UIEdgeInsets(top: 30, left: 30, bottom: 10, right: 20)
//    
//    // MARK: - Views
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .thin)
//        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        label.text = "쇼핑 기록  🛒"
//        return label
//    }()
//    
//    let subtitleLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
//        label.font = .systemFont(ofSize: 13, weight: .thin)
//        label.text = "오늘은 얼마를 사용하셨나요?"
//        return label
//    }()
//    
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.spacing = 10.0
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.layer.cornerRadius = 10
//        return stackView
//    }()
//    
//    let seperatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1).withAlphaComponent(0.11)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    // MARK: - Initializers
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        backgroundColor = .white
//        
//        addSubview(stackView)
//        addSubview(seperatorView)
//
//        setupConstraints()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Layout
//    
//    func setupConstraints() {
//        
//        stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom).isActive = true
//        
//        seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        seperatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
//    }
//}
