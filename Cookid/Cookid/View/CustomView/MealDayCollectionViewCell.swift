//
//  MealDayCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import UIKit
import Kingfisher

class MealDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mealImage.makeCircleView()
    }
    
    func updateUI(meal: Meal) {
        mealImage.kf.setImage(with: meal.image, placeholder: UIImage(systemName: "circle.fill"))
    }
    
}
