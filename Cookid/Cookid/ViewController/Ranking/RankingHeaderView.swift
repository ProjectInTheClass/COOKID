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
    
    let headbackgroundView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.makeShadow()
    }
    
    // rank 1
    
    let ranker1Image = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.preferredSymbolConfiguration = .init(pointSize: 55)
        $0.tintColor = #colorLiteral(red: 1, green: 0.7372836668, blue: 0.4183232817, alpha: 1)
    }
    
    let ranker1Name = UILabel().then {
        $0.text = "나는짱이다"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let ranker1Type = UILabel().then {
        $0.text = "#집밥러"
        $0.textAlignment  = .center
        $0.textColor = .systemBlue
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
    }
    
    let rank1RecordImage = UILabel().then {
        $0.text = "🍚"
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    
    let ranker1Record = UILabel().then {
        $0.text = "100"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    // rank 2
    
    let ranker2Image = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.preferredSymbolConfiguration = .init(pointSize: 50)
        $0.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    let ranker2Name = UILabel().then {
        $0.text = "집밥킬러"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let ranker2Type = UILabel().then {
        $0.text = "#집밥러"
        $0.textAlignment  = .center
        $0.textColor = .systemBlue
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
    }
    
    let rank2RecordImage = UILabel().then {
        $0.text = "🍚"
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
        
    let ranker2Record = UILabel().then {
        $0.text = "90"
        $0.textAlignment  = .natural
        $0.font = UIFont.systemFont(ofSize: 14, weight: .black)
    }
    
    // rank 3
    
    let ranker3Image = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.preferredSymbolConfiguration = .init(pointSize: 50)
        $0.tintColor = #colorLiteral(red: 0.8168092758, green: 0.522914351, blue: 0.3501365176, alpha: 1)
    }
        
    let ranker3Name = UILabel().then {
        $0.text = "천가닥버섯"
        $0.minimumScaleFactor = 15.0
        $0.textAlignment = .center
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
    }
    
    let ranker3Type = UILabel().then {
        $0.text = "#집밥러"
        $0.textAlignment  = .center
        $0.textColor = .systemBlue
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
    }
    
    let rank3RecordImage = UILabel().then {
        $0.text = "🍚"
        $0.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
    }
    
    let ranker3Record = UILabel().then {
        $0.text = "80"
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
        configureHeadBackgroundView()
        configureStackView()
    }
    
    // MARK: - ConfigureUI
    
    private func configureHeadBackgroundView() {
        self.addSubview(headbackgroundView)
        headbackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-15)
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
        }
    }
    
    private func configureStackView() {
        
        let rank1RecordStack = UIStackView(arrangedSubviews: [rank1RecordImage, ranker1Record])
        rank1RecordStack.alignment = .bottom
        rank1RecordStack.distribution = .fillProportionally
        rank1RecordStack.axis = .horizontal
        rank1RecordStack.spacing = 5
        
        let rank1Stack = UIStackView(arrangedSubviews: [ranker1Image, ranker1Name, ranker1Type, rank1RecordStack])
        rank1Stack.alignment = .center
        rank1Stack.distribution = .fillProportionally
        rank1Stack.axis = .vertical
        rank1Stack.spacing = 5
        
        let rank2RecordStack = UIStackView(arrangedSubviews: [rank2RecordImage, ranker2Record])
        rank2RecordStack.alignment = .bottom
        rank2RecordStack.distribution = .fillProportionally
        rank2RecordStack.axis = .horizontal
        rank2RecordStack.spacing = 5
        
        let rank2Stack = UIStackView(arrangedSubviews: [ranker2Image, ranker2Name, ranker2Type, rank2RecordStack])
        rank2Stack.alignment = .center
        rank2Stack.distribution = .fillProportionally
        rank2Stack.axis = .vertical
        rank2Stack.spacing = 5
        
        let rank3RecordStack = UIStackView(arrangedSubviews: [rank3RecordImage, ranker3Record])
        rank3RecordStack.alignment = .bottom
        rank3RecordStack.distribution = .fillProportionally
        rank3RecordStack.axis = .horizontal
        rank3RecordStack.spacing = 5
        
        let rank3Stack = UIStackView(arrangedSubviews: [ranker3Image, ranker3Name, ranker3Type, rank3RecordStack])
        rank3Stack.alignment = .center
        rank3Stack.distribution = .fillProportionally
        rank3Stack.axis = .vertical
        rank3Stack.spacing = 5
        
        let topRankerStackView = UIStackView(arrangedSubviews: [rank2Stack, rank1Stack, rank3Stack])
        topRankerStackView.alignment = .center
        topRankerStackView.distribution = .fillEqually
        topRankerStackView.axis = .horizontal
        topRankerStackView.spacing = 5
        
        headbackgroundView.addSubview(topRankerStackView)
        topRankerStackView.snp.makeConstraints { make in
            make.height.equalTo(headbackgroundView).inset(20)
            make.width.equalTo(headbackgroundView).inset(20)
            make.centerX.centerY.equalTo(headbackgroundView)
        }
        
    }
    
    // MARK: - bindViewModel
    
    private func bindViewModel() {
        viewModel.output.topRanker
            .bind(onNext: { [weak self] userSection in
                self?.ranker1Name.text = userSection[0].items[0].nickname
                self?.ranker1Type.text = "# " + userSection[0].items[0].userType.rawValue
                self?.ranker1Record.text = "\(userSection[0].items[0].groceryMealSum)"
                self?.ranker2Name.text = userSection[0].items[1].nickname
                self?.ranker2Type.text = "# " + userSection[0].items[1].userType.rawValue
                self?.ranker2Record.text = "\(userSection[0].items[1].groceryMealSum)"
                self?.ranker3Name.text = userSection[0].items[2].nickname
                self?.ranker3Type.text = "# " + userSection[0].items[2].userType.rawValue
                self?.ranker3Record.text = "\(userSection[0].items[2].groceryMealSum)"
            })
            .disposed(by: disposeBag)
    }
}
