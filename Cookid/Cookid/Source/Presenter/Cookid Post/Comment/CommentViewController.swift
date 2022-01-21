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
    
    private var activityIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    private let commentTextFieldView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    
    private let userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let uploadButton = CookidButton().then {
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        $0.imageView?.contentMode = .scaleAspectFill
        $0.tintColor = .darkGray
        $0.buttonImage = image
        $0.isEnabled = false
    }
    
    private lazy var commentTextField = UITextField().then {
        $0.borderStyle = .none
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: commentTextFieldView.frame.height))
        $0.leftViewMode = .always
        $0.rightView = uploadButton
        $0.rightViewMode = .whileEditing
        $0.backgroundColor = .systemGray6
        $0.placeholder = "댓글 쓰기..."
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    private lazy var commentTextFieldLeftView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .clear
    }
    
    private lazy var leftViewUserNamaLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let subCommentCancelButton = CookidButton().then {
        let image = UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        $0.imageView?.contentMode = .scaleAspectFill
        $0.tintColor = .darkGray
        $0.buttonImage = image
    }
    
    private let commentHeaderView = CommentHeaderView(frame: .zero)
    
    var viewModel: CommentViewModel!
    var coordinator: PostCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSubviewUI()
    }
    
    private func configureUI() {
        navigationItem.title = "댓글 보기"
        view.backgroundColor = .systemBackground
        activityIndicator.startAnimating()
        commentHeaderView.updateUI(viewModel.post)
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
    
    private func configureSubviewUI() {
        userImage.layoutIfNeeded()
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 15
    }
    
    private func makeConstraints() {
        
        view.addSubview(commentHeaderView)
        view.addSubview(tableView)
        view.addSubview(commentTextFieldView)
        view.addSubview(activityIndicator)
        commentTextFieldView.addSubview(userImage)
        commentTextFieldView.addSubview(commentTextField)
        commentTextFieldLeftView.addSubview(leftViewUserNamaLabel)
        commentTextFieldLeftView.addSubview(subCommentCancelButton)
        
        commentHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(commentTextFieldView.snp.top)
        }
        
        commentTextFieldView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(55)
        }
        
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
            make.width.equalTo(userImage.snp.height).multipliedBy(1)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-15)
        }
        
        leftViewUserNamaLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        subCommentCancelButton.snp.makeConstraints { make in
            make.left.equalTo(leftViewUserNamaLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
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
                self.commentTextFieldView.snp.remakeConstraints { make in
                    make.height.equalTo(55)
                    make.left.equalTo(view.snp.left)
                    make.right.equalTo(view.snp.right)
                    make.bottom.equalTo(view.snp.bottomMargin).offset(margin)
                }
            })
            .disposed(by: rx.disposeBag)
        
        commentTextField.rx.text.orEmpty
            .bind(to: viewModel.input.commentContent)
            .disposed(by: rx.disposeBag)
        
        viewModel.output.commentValidation
            .bind(to: uploadButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        uploadButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, action in
                owner.viewModel.input.uploadButtonTapped.onNext(action)
                owner.commentTextField.resignFirstResponder()
                owner.commentTextField.text = ""
            })
            .disposed(by: rx.disposeBag)
        
        subCommentCancelButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.commentTextField.resignFirstResponder()
                owner.commentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: owner.commentTextFieldView.frame.height))
                owner.viewModel.input.subCommentButtonTapped.onNext(nil)
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.output.user
            .withUnretained(self)
            .bind(onNext: { owner, user in
                owner.userImage.setUserImageWithKf(url: user.image)
                owner.viewModel.fetchComments(user: user)
            })
            .disposed(by: rx.disposeBag)
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
            
            cell.reactor = CommentCellReactor(post: viewModel.post, comment: headerComment, userService: viewModel.userService)
            
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
            
            cell.subCommentButton.rx.tap
                .withLatestFrom(Observable.just(headerComment))
                .withUnretained(self)
                .bind(onNext: { owner, comment in
                    owner.viewModel.input.subCommentButtonTapped.onNext(comment)
                    owner.commentTextField.becomeFirstResponder()
                    owner.leftViewUserNamaLabel.text = headerComment.user.nickname
                    owner.commentTextField.leftView = owner.commentTextFieldLeftView
                })
                .disposed(by: cell.disposeBag)
            
            cell.deleteButton.rx.tap
                .withLatestFrom(Observable.just(headerComment))
                .bind(onNext: { [weak self] comment in
                    guard let self = self else { return }
                    self.coordinator?.presentAlertVCForDelete(post: self.viewModel.post, comment: headerComment)
                })
                .disposed(by: cell.disposeBag)
            
            cell.reportButton.rx.tap
                .withLatestFrom(Observable.just(headerComment))
                .bind(onNext: { [weak self] comment in
                    guard let self = self else { return }
                    self.coordinator?.presentAlertVCForReport(post: self.viewModel.post, comment: headerComment)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        } else {
            // indexPath.row에 -1을 해야 out of range가 안뜬다. 헤더 때문에 row는 +1을 했지만, item는 실제로 그만큼의 데이터가 없다.
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewController.subCommentCell, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            
            let subComment = viewModel.output.commentSections[indexPath.section].items[indexPath.row - 1]
            
            cell.reactor = CommentCellReactor(post: viewModel.post, comment: subComment, userService: self.viewModel.userService)
            
            cell.deleteButton.rx.tap
                .withLatestFrom(Observable.just(subComment))
                .bind(onNext: { [weak self] comment in
                    guard let self = self else { return }
                    self.coordinator?.presentAlertVCForDelete(post: self.viewModel.post, comment: subComment)
                })
                .disposed(by: cell.disposeBag)
            
            cell.reportButton.rx.tap
                .withLatestFrom(Observable.just(subComment))
                .bind(onNext: { [weak self] comment in
                    guard let self = self else { return }
                    self.coordinator?.presentAlertVCForReport(post: self.viewModel.post, comment: subComment)
                })
                .disposed(by: cell.disposeBag)
            
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
