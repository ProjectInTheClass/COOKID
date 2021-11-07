//
//  MyRecipeViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit
import Then

class MyRecipeViewController: BaseViewController, View {
    
    private let guideLabel = UILabel().then {
        $0.text = "⚠️ 준비 중인 페이지입니다.\n곧 좋은 서비스로 찾아뵙겠습니다:)"
        $0.textColor = .systemGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    var coordinator: MyPageCoordinator?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: MyRecipeReactor) {
        
    }

}
