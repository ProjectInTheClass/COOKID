//
//  DatePickerCellTableViewCell.swift
//  MyDatePicker
//
//  Created by 임현지 on 2021/04/19.
//

import UIKit

class DatePickerCell: UITableViewCell {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        datePicker.layer.cornerRadius = 15
        datePicker.layer.shadowColor = UIColor.gray.cgColor
        datePicker.layer.shadowOpacity = 0.6
        datePicker.layer.shadowRadius = 10
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
