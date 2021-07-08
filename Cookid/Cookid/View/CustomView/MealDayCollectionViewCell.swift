//
//  MealDayCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/09.
//

import UIKit

class MealDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mealImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mealImage.makeCircleView()
        contentView.makeCircleView()
    }
    
    func updateUI(meal: Meal) {
        mealImage.image = UIImage(systemName: meal.image)
        mealImage.image?.withTintColor(.white, renderingMode: .automatic)
    }
    
}
