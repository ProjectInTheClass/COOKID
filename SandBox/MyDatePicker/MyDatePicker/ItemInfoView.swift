//
//  ItemInfoView.swift
//  MyDatePicker
//
//  Created by 임현지 on 2021/04/30.
//

import UIKit

class ItemInfoView: UIView {
    
    let iconImageView = UIImageView()
    let dateLabel = ItemLabel(textAlignment: .left, fontSize: 16)
    let descriptionLabel = ItemLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(iconImageView)
        addSubview(dateLabel)
        addSubview(descriptionLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleToFill
        iconImageView.tintColor = .label
        iconImageView.image = UIImage(systemName: "")
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            dateLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
}
