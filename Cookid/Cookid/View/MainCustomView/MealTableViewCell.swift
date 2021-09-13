//
//  MealTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/07.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealCellImage: UIImageView!
    @IBOutlet weak var mealCellName: UILabel!
    @IBOutlet weak var mealCellPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mealCellImage.makeCircleView()
    }

}
