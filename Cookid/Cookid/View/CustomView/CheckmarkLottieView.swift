//
//  CheckmarkLottieView.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/09.
//

import UIKit
import Lottie

class CheckmarkLottieView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        checkmarkAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkmarkAnimation() {
        let animationView = AnimationView()
        let animation = Animation.named("checkmark-icon")
        
        animationView.animation = animation
        animationView.tintColor = .systemYellow
        animationView.center = self.center
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        
        animationView.play()
        
        self.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: self.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

}
