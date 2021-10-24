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
    static let subCommentCell = "subCommentCell"
    static let parentCommentCell = "parentCommentCell"
    
    private let commentInputTextFieldView = CommentInputView(frame: .zero)
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: subCommentCell)
        $0.register(ParentCommentTableViewCell.self, forCellReuseIdentifier: parentCommentCell)
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .systemBackground
    }
    
    private var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }

    var disposeBag = DisposeBag()
    
    var commentSections = [CommentSection]() {
        didSet {
            self.tableView.reloadData()
            commentSections.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
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
        tableView.delegate = self
        tableView.dataSource = self
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
        .withUnretained(self)
        .bind(onNext: { owner, sections in
            owner.commentSections = sections
        })
        .disposed(by: disposeBag)
        
    }

}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let commentSection = commentSections[section]
        if commentSection.isOpened {
            // 0번째는 section의 헤더, 나머지는 items이기 때문에 items 숫자 + 헤더 때문에 + 1
            return commentSection.items.count + 1
        } else {
            // 헤더만
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor = reactor else { return UITableViewCell() }
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.parentCommentCell, for: indexPath) as? ParentCommentTableViewCell else { return UITableViewCell() }
            let headerComment = commentSections[indexPath.section].header
            cell.reactor = CommentCellReactor(post: reactor.post, comment: headerComment, commentService: reactor.commentService, userService: reactor.userService)
            
            if commentSections[indexPath.section].items.isEmpty {
                cell.detailSubCommentButton.isEnabled = false
            } else {
                cell.detailSubCommentButton.isEnabled = true
            }
            
            cell.detailSubCommentButton.rx.tap
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                    UIView.setAnimationsEnabled(false)
                    owner.commentSections[indexPath.section].isOpened = !owner.commentSections[indexPath.section].isOpened
                    tableView.reloadSections([indexPath.section], with: .fade)
                    UIView.setAnimationsEnabled(true)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
            
        } else {
            // indexPath.row에 -1을 해야 out of range가 안뜬다. 헤더 때문에 row는 +1을 했지만, item는 실제로 그만큼의 데이터가 없다.
            let subComment = commentSections[indexPath.section].items[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.subCommentCell, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.reactor = CommentCellReactor(post: reactor.post, comment: subComment, commentService: reactor.commentService, userService: reactor.userService)
            return cell
        }
    }
    
    // 테이블뷰의 스타일이 그룹드 일 때, 섹션 사이의 갭이 생긴다. 그걸 없애주는 코드
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
