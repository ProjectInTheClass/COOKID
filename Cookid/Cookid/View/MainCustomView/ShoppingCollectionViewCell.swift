//
//  ShoppingCollectionViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/23.
//

import UIKit

class ShoppingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shoppingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shoppingImage.makeCircleView()
    }
    
    func updateUI(shopping: GroceryShopping) {
        self.shoppingImage.image = shopping.image
    }
    
}
