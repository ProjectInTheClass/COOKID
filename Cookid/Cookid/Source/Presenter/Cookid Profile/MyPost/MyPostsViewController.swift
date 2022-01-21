//
//  MyPostsViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/09.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class MyPostsViewController: UIViewController, View {
    static let myPostCellIdentifier = "myPostCellIdentifier"
    
    var coordinator: MyPageCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPostTableViewCell.self, forCellReuseIdentifier: myPostCellIdentifier)
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
    }
    
    private let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "placeholder")
    }
    
    private let backgroundLabel = UILabel().then {
        $0.text = "내 글이 없습니다.\n추천하고 싶은 식사를 포스팅 해보세요."
        $0.textAlignment = .center
        $0.textColor = .systemGray4
        $0.numberOfLines = 2
    }
    
    private lazy var backgroundStackView = UIStackView(arrangedSubviews: [backgroundImage, backgroundLabel]).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        backgroundImage.layer.cornerRadius = backgroundImage.frame.height / 2
        backgroundImage.layer.masksToBounds = true
    }
    
    func bind(reactor: MyPostReactor) {
        
        reactor.state.map { $0.isError }
        .bind(onNext: { isError in
            guard let isError = isError else { return }
            if isError {
                errorAlert(selfView: self, errorMessage: "내 글을 삭제하지 못했습니다.\n다시 시도해 주세요", completion: {})
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.myPosts }
        .observe(on: MainScheduler.instance)
        .do(onNext: { [weak self] posts in
            guard let self = self else { return }
            self.backgroundStackView.isHidden = posts.count != 0
        })
        .bind(to: tableView.rx.items(cellIdentifier: MyPostsViewController.myPostCellIdentifier, cellType: MyPostTableViewCell.self)) { _, item, cell in
            cell.reactor = MyPostTableViewCellReactor(post: item, userService: reactor.userService)
            cell.settingButton.rx.tap
                .bind {
                    self.coordinator?.presentEditActionSheet(post: item)
                }
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: rx.disposeBag)
        
        Observable.zip(
            tableView.rx.modelSelected(Post.self),
            tableView.rx.itemSelected,
            resultSelector: { ($0, $1)})
            .bind { [unowned self] (post, indexPath) in
                self.tableView.deselectRow(at: indexPath, animated: false)
                postCoordinator.navigateCommentVC(post: post)
            }
            .disposed(by: disposeBag)
    }
    
    func makeConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        view.addSubview(backgroundStackView)
        backgroundStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.width.height.equalTo(view.snp.width).multipliedBy(0.33)
        }
    }
}
