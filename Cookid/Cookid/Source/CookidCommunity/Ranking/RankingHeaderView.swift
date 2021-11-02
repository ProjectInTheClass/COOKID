//
//  RankingHeaderView.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SnapKit
import Then
import Kingfisher

class RankingHeaderView: UIView, HasDisposeBag {
    
    // MARK: - properties
    
    var viewModel: RankingViewModel!
    
    let rankerImage = RankerImageView().then {
        $0.circleColor = .systemYellow
        $0.rankImage = UIImage(named: "goldMedal")
    }
    
    let secondRankerImage = RankerImageView().then {
        $0.circleColor = .systemGray5
        $0.rankImage = UIImage(named: "silverMedal")
    }
    
    let thirdRankerImage = RankerImageView().then {
        $0.circleColor = .systemBrown
        $0.rankImage = UIImage(named: "bronzeMedal")
    }
   
    let rankerName = UILabel().then {
        $0.text = "닉네임"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let secondRankerName = UILabel().then {
        $0.text = "닉네임"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let thirdRankerName = UILabel().then {
        $0.text = "닉네임"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let rankRecordImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "Cookid")
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let secondRankRecordImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "Cookid")
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let thirdRankRecordImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "Cookid")
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let rankerRecord = UILabel().then {
        $0.text = "0"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    let secondRankerRecord = UILabel().then {
        $0.text = "0"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    let thirdRankerRecord = UILabel().then {
        $0.text = "0"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, viewModel: RankingViewModel) {
        self.init(frame: frame)
        self.viewModel = viewModel
        bindViewModel()
        self.backgroundColor = .systemBackground
        makeConstraints()
    }
    
    // MARK: - ConfigureUI
  
    func makeConstraints() {
        
        self.addSubview(rankerImage)
        rankerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
            make.height.width.equalTo(110)
        }
        
        self.addSubview(rankerName)
        rankerName.snp.makeConstraints { make in
            make.top.equalTo(rankerImage.snp.bottom).offset(10)
            make.centerX.equalTo(rankerImage)
        }
        
        let recordStackView = UIStackView(arrangedSubviews: [rankRecordImage, rankerRecord]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 5
        }

        self.addSubview(recordStackView)
        recordStackView.snp.makeConstraints { make in
            make.top.equalTo(rankerName.snp.bottom).offset(5)
            make.centerX.equalTo(rankerName)
            make.height.equalTo(20)
        }
        
        self.addSubview(secondRankerImage)
        secondRankerImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(rankerImage.snp.left).offset(-20)
            make.bottom.equalTo(rankerImage.snp.bottom)
            make.height.equalTo(secondRankerImage.snp.width).multipliedBy(1)
        }
        
        self.addSubview(secondRankerName)
        secondRankerName.snp.makeConstraints { make in
            make.top.equalTo(secondRankerImage.snp.bottom).offset(10)
            make.centerX.equalTo(secondRankerImage)
        }
        
        let secondRecordStackView = UIStackView(arrangedSubviews: [secondRankRecordImage, secondRankerRecord]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 5
        }

        self.addSubview(secondRecordStackView)
        secondRecordStackView.snp.makeConstraints { make in
            make.top.equalTo(secondRankerName.snp.bottom).offset(5)
            make.centerX.equalTo(secondRankerName)
            make.height.equalTo(20)
        }
        
        self.addSubview(thirdRankerImage)
        thirdRankerImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(rankerImage.snp.right).offset(20)
            make.bottom.equalTo(rankerImage.snp.bottom)
            make.height.equalTo(thirdRankerImage.snp.width).multipliedBy(1)
        }
        
        self.addSubview(thirdRankerName)
        thirdRankerName.snp.makeConstraints { make in
            make.top.equalTo(thirdRankerImage.snp.bottom).offset(10)
            make.centerX.equalTo(thirdRankerImage)
        }
        
        let thirdRecordStackView = UIStackView(arrangedSubviews: [thirdRankRecordImage, thirdRankerRecord]).then {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.spacing = 5
        }

        self.addSubview(thirdRecordStackView)
        thirdRecordStackView.snp.makeConstraints { make in
            make.top.equalTo(thirdRankerName.snp.bottom).offset(5)
            make.centerX.equalTo(thirdRankerName)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - bindViewModel
    
    private func bindViewModel() {
        viewModel.output.cookidTopRankers
            .drive(onNext: { [weak self] users in
                self?.rankerImage.userImageView.setImageWithKf(url: users[0].image)
                self?.rankerName.text = users[0].nickname
                self?.rankerRecord.text = String(describing: users[0].cookidsCount)
                
                self?.secondRankerImage.userImageView.setImageWithKf(url: users[1].image)
                self?.secondRankerName.text = users[1].nickname
                self?.secondRankerRecord.text = String(describing: users[1].cookidsCount)
                
                self?.thirdRankerImage.userImageView.setImageWithKf(url: users[2].image)
                self?.thirdRankerName.text = users[2].nickname
                self?.thirdRankerRecord.text = String(describing: users[2].cookidsCount)
            })
            .disposed(by: disposeBag)
    }
}
