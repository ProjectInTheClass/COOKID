//
//  MyPostsViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import NSObject_Rx

class MyPostsViewController: UIViewController, ViewModelBindable {
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPostTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.postCell)
    }
    
    var viewModel: MyPageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        
    }

}
