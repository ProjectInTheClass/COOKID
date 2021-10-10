//
//  CommentViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

class CommentViewController: UIViewController, View {
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.commentCell)
        $0.separatorStyle = .none
    }

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
    
    func bind(reactor: CommentReactor) {
        reactor.state.map { $0.commentReactors }
        .bind(to: tableView.rx.items(cellIdentifier: CELLIDENTIFIER.commentCell, cellType: CommentTableViewCell.self)) { _, item, cell in
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
