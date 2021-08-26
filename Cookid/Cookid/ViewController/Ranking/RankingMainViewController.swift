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
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tv.register(RankingTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.rankingCell)
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
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel() {
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.topRanker
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: rx.disposeBag)
        
    }
    
}

extension RankingMainViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RankingHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), viewModel: self.viewModel)
        headerView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        footerView.backgroundColor = .systemBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
}
