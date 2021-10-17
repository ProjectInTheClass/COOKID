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
import RxKeyboard

class CommentViewController: UIViewController, View {
    static let headerviewIdentifier = "commentHeaderView"
    
    private let commentHeaderView = CommentHeaderView(frame: .zero)
    
    private let commentInputTextFieldView = CommentInputTextField(frame: .zero)
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER.commentCell)
        $0.separatorStyle = .none
        $0.allowsSelection = false
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "댓글 보기"
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        
        view.addSubview(commentInputTextFieldView)
        commentInputTextFieldView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(55)
        }
        
        commentInputTextFieldView.reactor = reactor
    }
    
    func bind(reactor: CommentReactor) {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let margin = height != 0 ? -height + view.safeAreaInsets.bottom : 0
                self.commentInputTextFieldView.snp.remakeConstraints { make in
                    make.height.equalTo(55)
                    make.left.equalTo(view.snp.left)
                    make.right.equalTo(view.snp.right)
                    make.bottom.equalTo(view.snp.bottomMargin).offset(margin)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comments }
        .bind(to: tableView.rx.items(cellIdentifier: CELLIDENTIFIER.commentCell, cellType: CommentTableViewCell.self)) { _, item, cell in
            cell.reactor = CommentCellReactor(post: reactor.post, comment: item, commentService: reactor.commentService, userService: reactor.userService)
        }
        .disposed(by: disposeBag)
        
        commentHeaderView.updateUI(post: reactor.post)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

}

extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return commentHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
