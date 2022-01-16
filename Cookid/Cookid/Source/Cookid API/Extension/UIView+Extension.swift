//
//  UIView+Extension.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/27.
//

import UIKit
import Kingfisher

extension UIView {
    
    func makeShadow() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.systemGray3.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
    }
    
    func makeCircleView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func makeOutsideStroke(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        path.stroke()
        UIColor.systemGray6.setStroke()
        path.lineWidth = 0.5
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height)/2)
        setContentOffset(bottomOffset, animated: true)
    }
}

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}

extension UIImageView {
    
    func setImageWithKf(url: URL?) {
        let placeholder = UIImage(named: "placeholder")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder,
                         options: [
                            .transition(.fade(0.2)),
                            .scaleFactor(UIScreen.main.scale)
                         ])
    }
    
    func setUserImageWithKf(url: URL?) {
        let placeholder = UIImage(named: "personPlaceholder")
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder,
                         options: [
                            .transition(.fade(0.2)),
                            .scaleFactor(UIScreen.main.scale),
                            .diskCacheExpiration(.expired)
                         ])
    }
    
}
