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
    
    static let identifier = "resultCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var label = UILabel().then{
        $0.text = "여기에는 내 식사? 내 외식? 리스트?"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 25)
    }
    
    lazy var dateLabel = UILabel().then{
        $0.text = ""
        $0.textColor = .darkGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    lazy var mealImage = UIImageView().then{
        $0.image = UIImage(named: "camera")
    }
    
    
    private func setUpConstraint() {
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        contentView.addSubview(mealImage)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        mealImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.mealImage.snp.makeConstraints{
            $0.height.width.equalTo(20)
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        self.label.snp.makeConstraints{
            $0.leading.equalTo(mealImage.snp.trailing).offset(10)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        self.dateLabel.snp.makeConstraints{
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
