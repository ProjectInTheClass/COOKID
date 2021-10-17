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
        makeConstraints()
        configureUI()
    }
    
    // MARK: - Functions
    
    private func makeConstraints() {
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
    }
    
    // MARK: - Bind ViewModel
    
    func bindViewModel() {
        
        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.cookidRankers
            .bind(to: tableView.rx.items(cellIdentifier: CELLIDENTIFIER.rankingCell, cellType: RankingTableViewCell.self)) { index, item, cell in
                cell.updateUI(user: item, ranking: index)
            }
            .disposed(by: rx.disposeBag)
        
    }
    
}

extension RankingMainViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RankingHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), viewModel: self.viewModel)
        headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
}
