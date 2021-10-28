//
//  CookidButton.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/17.
//

import UIKit

class CookidButton: UIButton {
    
    /// 버튼의 색깔
    public var buttonColor: UIColor = .gray {
        didSet {
            self.tintColor = buttonColor
        }
    }
    
    public var buttonTitle: String? {
        didSet {
            self.setTitle(buttonTitle, for: .normal)
        }
    }
    
    public var buttonTitleColor: UIColor = DefaultStyle.Color.labelTint {
        didSet {
            self.setTitleColor(buttonTitleColor, for: .normal)
        }
    }
    
    public var buttonFontWeight: UIFont.Weight = .regular {
        didSet {
            self.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: buttonFontWeight)
        }
    }
    
    public var buttonFontSize: CGFloat = 17 {
        didSet {
            self.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: buttonFontWeight)
        }
    }
    
    public var buttonImage: UIImage? {
        didSet {
            self.setImage(buttonImage, for: .normal)
        }
    }
    
    public var isAnimate: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonAnimate), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonAnimate), for: .touchUpInside)
    }
    
    @objc private func buttonAnimate() {
        guard !isAnimate else { return }
        UIView.animate(withDuration: 0.1,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
        },
                       completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                guard let self = self else { return }
                self.transform = .identity
            }
        })
    }
    
}
