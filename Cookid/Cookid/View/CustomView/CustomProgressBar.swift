//
//  CustomProgressBar.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/06.
//

import UIKit

@IBDesignable
class PlainHorizontalProgressBar: UIView {
    @IBInspectable var color: UIColor? = .lightGray
    
    var progress: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    private let progressLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.addSublayer(progressLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        backgroundColor?.setFill()
        
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
       
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color?.cgColor
    }
    
    
}
