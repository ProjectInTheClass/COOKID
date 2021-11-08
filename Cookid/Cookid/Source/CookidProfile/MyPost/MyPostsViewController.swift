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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        makeConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func bind(reactor: MyPostReactor) {
        reactor.state.map { $0.myPosts }
        .bind(to: tableView.rx.items(cellIdentifier: MyPostsViewController.myPostCellIdentifier, cellType: MyPostTableViewCell.self)) { _, item, cell in
                    cell.updateUI(post: item)
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(Post.self)
            .withUnretained(self)
            .bind { owner, post in
                guard let postCoordinator = owner.coordinator?.parentCoordinator.childCoordinator[1] as? PostCoordinator else { return }
                postCoordinator.navigateCommentVC(rootNaviVC: owner.coordinator?.navigationController, post: post)
            }
            .disposed(by: disposeBag)
    }
    
    func makeConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
