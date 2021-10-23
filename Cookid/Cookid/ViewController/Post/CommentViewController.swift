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
    static let commentCell = "commentCell"
    
    private let commentInputTextFieldView = CommentInputView(frame: .zero)
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentViewController.commentCell)
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .systemBackground
    }
    
    private var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }

    var disposeBag = DisposeBag()
    
    var commentHeaderViews = [CommentHeaderView]() {
        didSet {
            self.tableView.reloadData()
            commentHeaderViews.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "댓글 보기"
        view.backgroundColor = .systemBackground
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        view.addSubview(commentInputTextFieldView)
        view.addSubview(activityIndicator)
        
        tableView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.bottom.equalTo(commentInputTextFieldView.snp.top)
        }
        
        commentInputTextFieldView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(55)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
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
        
        reactor.state.map { $0.commentSections }
        .observe(on: MainScheduler.instance)
        .do(onNext: { [unowned self] section in
            let headerViews = section
                .map { $0.header }
                .map { CommentCellReactor(post: reactor.post, comment: $0, commentService: reactor.commentService, userService: reactor.userService) }
                .map { reactor -> CommentHeaderView in
                    let commentHeaderView = CommentHeaderView(frame: .zero)
                    commentHeaderView.reactor = reactor
                    return commentHeaderView
                }
            self.commentHeaderViews = headerViews
        })
        .bind(to: tableView.rx.items(dataSource: reactor.dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

}

extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return commentHeaderViews[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 테이블뷰의 스타일이 그룹드 일 때, 섹션 사이의 갭이 생긴다. 그걸 없애주는 코드
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
