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
import SnapKit
import Then

class CommentViewController: UIViewController, View {
    static let headerviewIdentifier = "commentHeaderView"
    
    private let commentHeaderView = CommentHeaderView(reuseIdentifier: headerviewIdentifier)
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.commentCell)
        $0.separatorStyle = .none
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "댓글 보기"
        tableView.contentInsetAdjustmentBehavior = .always
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    
    func bind(reactor: CommentReactor) {
        
        reactor.state.map { $0.comments }
        .bind(to: tableView.rx.items(cellIdentifier: CELLIDENTIFIER.commentCell, cellType: CommentTableViewCell.self)) { _, item, cell in
            print("✅ \(item)")
            cell.reactor = CommentCellReactor(post: reactor.post, comment: item, commentService: reactor.commentService, userService: reactor.userService)
        }
        .disposed(by: disposeBag)
        
        commentHeaderView.updateUI(post: reactor.post)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension CommentViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return commentHeaderView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
