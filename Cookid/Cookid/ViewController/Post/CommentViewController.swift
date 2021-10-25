//
//  CommentViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxKeyboard
import NSObject_Rx

class CommentViewController: UIViewController, ViewModelBindable {
    static let subCommentCell = "subCommentCell"
    static let parentCommentCell = "parentCommentCell"
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: subCommentCell)
        $0.register(ParentCommentTableViewCell.self, forCellReuseIdentifier: parentCommentCell)
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .systemBackground
    }
    
    private let commentInputTextFieldView = CommentInputView(frame: .zero)
    
    private var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    var viewModel: CommentViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    private func configureUI() {
        navigationItem.title = "댓글 보기"
        view.backgroundColor = .systemBackground
        activityIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.output.onUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
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
    }
    
    func bindViewModel() {
        
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
            .disposed(by: rx.disposeBag)
        
        viewModel.fetchComments()
    }

}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.commentSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let commentSection = viewModel.output.commentSections[section]
        if commentSection.isOpened {
            // 0번째는 section의 헤더, 나머지는 items이기 때문에 items 숫자 + 헤더 때문에 + 1
            return commentSection.items.count + 1
        } else {
            // 헤더만
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.parentCommentCell, for: indexPath) as? ParentCommentTableViewCell else { return UITableViewCell() }
            
            let headerComment = viewModel.output.commentSections[indexPath.section].header
            
            cell.reactor = CommentCellReactor(post: viewModel.output.post, comment: headerComment, commentService: viewModel.commentService, userService: viewModel.userService)
            
            self.cellStateUpdate(cell: cell, target: viewModel.output.commentSections[indexPath.section])
            
            cell.detailSubCommentButton.rx.tap
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                    UIView.setAnimationsEnabled(false)
                    owner.viewModel.output.commentSections[indexPath.section].isOpened = !owner.viewModel.output.commentSections[indexPath.section].isOpened
                    tableView.reloadSections([indexPath.section], with: .fade)
                    UIView.setAnimationsEnabled(true)
                })
                .disposed(by: cell.disposeBag)
            
//            cell.subCommentButton.rx.tap
//                .map { Reactor.Action.addSubComment }
//                .bind(to: reactor.action)
//                .disposed(by: disposeBag)
            
            return cell
        } else {
            // indexPath.row에 -1을 해야 out of range가 안뜬다. 헤더 때문에 row는 +1을 했지만, item는 실제로 그만큼의 데이터가 없다.
            let subComment = viewModel.output.commentSections[indexPath.section].items[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.subCommentCell, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.reactor = CommentCellReactor(post: viewModel.output.post, comment: subComment, commentService: viewModel.commentService, userService: viewModel.userService)
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
    
    func cellStateUpdate(cell: ParentCommentTableViewCell, target: CommentSection) {
        if target.items.isEmpty {
            cell.detailSubCommentButton.isEnabled = false
            cell.detailSubCommentButton.isHidden = true
        } else {
            cell.detailSubCommentButton.isEnabled = true
            cell.detailSubCommentButton.isHidden = false
        }
        target.isOpened ? cell.detailSubCommentButton.setTitle("답글 닫기", for: .normal) : cell.detailSubCommentButton.setTitle("답글 보기", for: .normal)
    }
}
