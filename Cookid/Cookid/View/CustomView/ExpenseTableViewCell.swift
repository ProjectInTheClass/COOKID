//
//  CustumTableViewCell.swift
//  Cookid
//
//  Created by Sh Hong on 2021/07/09.
//

import UIKit
import SnapKit
import Then

class ExpenseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let identifier = "ExpenseTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var titlelabel = UILabel().then{
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17)
    }
    
    lazy var dateLabel = UILabel().then{
        $0.text = ""
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 15)
    }
    
//    lazy var mealImage = UIImageView().then{
//        $0.image = UIImage(named: "camera")
//    }
    
    
    private func setUpConstraint() {
        contentView.addSubview(titlelabel)
        contentView.addSubview(dateLabel)
//        contentView.addSubview(mealImage)
        
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.mealImage.snp.makeConstraints{
//            $0.height.width.equalTo(20)
//            $0.leading.equalToSuperview().offset(10)
//            $0.centerY.equalTo(contentView.snp.centerY)
//        }
        
        self.titlelabel.snp.makeConstraints{
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        self.dateLabel.snp.makeConstraints{
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func updateCell(title: String, date: String) {
        titlelabel.text = title
        dateLabel.text = date
    }
}
