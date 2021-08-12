//
//  RankingMainViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/08/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RankingMainViewController: UIViewController, ViewModelBindable {
    
    var viewModel: RankingViewModel!
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
       let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER.rankingCell)
        return tv
    }()
    

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Functions
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        
        print("binding")
        // MARK: - BindViewModel Input
        
        
        
        // MARK: - BindViewModel Output
        
        
    }
    
    
}
