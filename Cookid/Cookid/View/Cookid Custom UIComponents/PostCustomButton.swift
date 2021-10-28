//
//  PostCustomButton.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/15.
//

import UIKit

class HeartButton: UIButton {
    
    var isActivated: Bool = false
    let activeButtonImage = UIImage(systemName: "suit.heart.fill")!
    let inActiveButtonImage = UIImage(systemName: "suit.heart")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }
    
    func setState(_ newValue: Bool) {
        self.isActivated = newValue
        self.tintColor = self.isActivated ? .systemRed : DefaultStyle.Color.labelTint
        self.setImage(self.isActivated ? activeButtonImage : inActiveButtonImage, for: .normal)
    }
    
    @objc func heartButtonTapped() {
        self.isActivated.toggle()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.tintColor = self.isActivated ? .systemRed : DefaultStyle.Color.labelTint
            let image = self.isActivated ? self.activeButtonImage : self.inActiveButtonImage
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
            self.setImage(image, for: .normal)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
}

class BookmarkButton: UIButton {
    
    var isActivated: Bool = false
    let activeButtonImage = UIImage(systemName: "bookmark.fill")
    let inActiveButtonImage = UIImage(systemName: "bookmark")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        self.tintColor = DefaultStyle.Color.labelTint
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        self.tintColor = DefaultStyle.Color.labelTint
    }
    
    func setState(_ newValue: Bool) {
        self.isActivated = newValue
        self.setImage(self.isActivated ? activeButtonImage : inActiveButtonImage, for: .normal)
    }
    
    @objc func bookmarkButtonTapped() {
        self.isActivated.toggle()
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            let image = self.isActivated ? self.activeButtonImage : self.inActiveButtonImage
            self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
            self.setImage(image, for: .normal)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
            
        }
    }
}
