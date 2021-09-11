//
//  MyRecipesViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx

class MyRecipesViewController: UIViewController, ViewModelBindable {
    
    private let annouceImage = UILabel().then {
        $0.text = "🚧"
        $0.font = UIFont.systemFont(ofSize: 40, weight: .light)
        $0.textAlignment = .center
    }
    
    private let annouceLabel = UILabel().then {
        $0.text = "아직 준비 중입니다:)"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .light)
        $0.textAlignment = .center
        $0.textColor = .systemGray
        $0.numberOfLines = 0
    }

    var viewModel: MyPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func makeConstraints() {
        let annouceStackView = UIStackView(arrangedSubviews: [annouceImage, annouceLabel]).then {
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 5
            $0.axis = .vertical
        }
        view.addSubview(annouceStackView)
        annouceStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        
    }

}
