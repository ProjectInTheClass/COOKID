//
//  MealTimeCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/07.
//

import UIKit

class MealTimeCollectionViewCell: UICollectionViewCell {
    
    let barView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2562616467, green: 0.7466452718, blue: 0.5671476722, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    @IBOutlet weak var mealTimeTitle: UILabel!
    
    
    var heightConstraints: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(barView)
        heightConstraints = barView.heightAnchor.constraint(equalToConstant: 100)
        heightConstraints?.isActive = true
        barView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        barView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        barView.bottomAnchor.constraint(equalTo: mealTimeTitle.topAnchor).isActive = true
    }
    
    func updateUI(ratio: CGFloat, name: String) {
        mealTimeTitle.text = name
        heightConstraints?.constant = (frame.height - mealTimeTitle.frame.height) * ratio
    }
    
}
