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
import RxDataSources

class RankingMainViewController: UIViewController, ViewModelBindable {
    
    var viewModel: RankingViewModel!
    
    // MARK: - Properties
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(RankingTableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER.rankingCell)
        tv.separatorStyle = .none
        return tv
    }()
    

    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraints()
        configureUI()
    }
    
    // MARK: - Functions
    
    private func configureConstraints() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func configureUI() {
        title = "Cookid Rank"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    func bindViewModel() {
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        print("binding")
        // MARK: - BindViewModel Input
        
        viewModel.output.topRanker
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
        
        // MARK: - BindViewModel Output
        
        
    }
    
}

extension RankingMainViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RankingHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height),viewModel: self.viewModel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
}
