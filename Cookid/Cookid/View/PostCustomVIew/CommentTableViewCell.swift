//
//  CommentTableViewCell.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(comment: Comment) {
        
    }
    
}
