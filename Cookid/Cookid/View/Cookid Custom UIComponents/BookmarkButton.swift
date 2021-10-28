//
//  BookmarkButton.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/28.
//
import UIKit

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
