//
//  CustomProgressCircleView.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/08.
//

import UIKit

@IBDesignable
class PlainCircleProgressBar: UIView {
    @IBInspectable var color: UIColor? = #colorLiteral(red: 0.9508261085, green: 0.8531606793, blue: 0.6693316102, alpha: 1)
    @IBInspectable var ringWidth: CGFloat = 50
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private let backgroundMask = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath
        backgroundMask.lineWidth = ringWidth
        
        progressLayer.shadowPath = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.lineWidth = ringWidth
        
        if progress > 0 && progress <= 0.25 {
            progressLayer.strokeColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        } else if progress <= 0.5 {
            progressLayer.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        } else if progress <= 0.75 {
            progressLayer.strokeColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else {
            progressLayer.strokeColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
    }
    
    private func setupLayers() {
        
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        
        progressLayer.shadowColor = UIColor.systemGray6.cgColor
        progressLayer.shadowOffset = CGSize(width: 0, height: 0)
        progressLayer.shadowOpacity = 1
        progressLayer.lineCap = .round
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90*Double.pi / 180), 0, 0, -1)
    }
    
}
