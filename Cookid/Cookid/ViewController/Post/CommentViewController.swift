//
//  CommentViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import ReactorKit
import RxDataSources

class CommentViewController: UIViewController, ViewModelBindable {
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.commentCell)
        $0.separatorStyle = .none
    }
    
    var viewModel: PostCellViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        
        viewModel.output.commentReactors
            .drive(tableView.rx.items(cellIdentifier: CELLIDENTIFIER.commentCell, cellType: CommentTableViewCell.self)) { datasource, item, cell in
                cell.reactor = item
            }
            .disposed(by: disposeBag)
        
    }

}

extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
