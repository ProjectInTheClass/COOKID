//
//  StarSliderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/10/28.
//

import UIKit
import Then
import SnapKit

/// custom properties
/// startColor: change color of stars
/// startPoint: change star point
class StarSlider: UISlider {
    
    public var starColor: UIColor? = .systemYellow {
        didSet {
            stars.forEach { $0.tintColor = starColor }
        }
    }

    public var starPoint: Int = 0 {
        didSet {
            setState(starPoint: starPoint)
            self.value = Float(starPoint)
            layoutIfNeeded()
        }
    }
    
    public var starMaxSize: CGFloat = 24 {
        didSet {
            stars.forEach {
                let config = UIImage.SymbolConfiguration(pointSize: starMaxSize)
                $0.image = UIImage(systemName: "star", withConfiguration: config)
            }
            setNeedsLayout()
        }
    }
    
    private var star1 = UIImageView().then {
        $0.tintColor = .systemYellow
        $0.image = UIImage(systemName: "star")
        $0.tag = 1
        $0.contentMode = .scaleAspectFit
    }
    
    private var star2 = UIImageView().then {
        $0.tintColor = .systemYellow
        $0.image = UIImage(systemName: "star")
        $0.tag = 2
        $0.contentMode = .scaleAspectFit
    }
    
    private var star3 = UIImageView().then {
        $0.tintColor = .systemYellow
        $0.image = UIImage(systemName: "star")
        $0.tag = 3
        $0.contentMode = .scaleAspectFit
    }
    
    private var star4 = UIImageView().then {
        $0.tintColor = .systemYellow
        $0.image = UIImage(systemName: "star")
        $0.tag = 4
        $0.contentMode = .scaleAspectFit
    }
    
    private var star5 = UIImageView().then {
        $0.tintColor = .systemYellow
        $0.image = UIImage(systemName: "star")
        $0.tag = 5
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var stars = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        makeconstraints()
        addActionSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        makeconstraints()
        addActionSlider()
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.minimumTrackTintColor = .clear
        self.maximumTrackTintColor = .clear
        self.thumbTintColor = .clear
        self.value = 0
        self.minimumValue = 0
        self.maximumValue = 5
        stars.append(star1)
        stars.append(star2)
        stars.append(star3)
        stars.append(star4)
        stars.append(star5)
    }
    
    private func addActionSlider() {
        self.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
    }
    
    private func makeconstraints() {
        let starStackView = UIStackView(arrangedSubviews: stars).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 3
        }

        self.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.sendSubviewToBack(starStackView)
    }
    
    @objc func didChangeSliderValue(_ sender: UISlider) {
        let value = Int(round(sender.value))
        setState(starPoint: value)
    }
    
    private func setState(starPoint: Int) {
        for index in 0...5 {
            if let tagView = self.viewWithTag(index) as? UIImageView {
                if index <= starPoint {
                    let config = UIImage.SymbolConfiguration(pointSize: starMaxSize)
                    tagView.image = UIImage(systemName: "star.fill", withConfiguration: config)
                } else {
                    let config = UIImage.SymbolConfiguration(pointSize: starMaxSize)
                    tagView.image = UIImage(systemName: "star", withConfiguration: config)
                }
            }
        }
    }
    
}
