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
        tableView.separatorStyle = .none
    }
    
    func bind(reactor: MyPostReactor) {
        
        reactor.state.map { $0.isError }
        .bind(onNext: { isError in
            guard let isError = isError else { return }
            if isError {
                errorAlert(selfView: self, errorMessage: "내 글을 삭제하지 못했습니다.\n다시 시도해 주세요", completion: { })
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.myPosts }
        .bind(to: tableView.rx.items(cellIdentifier: MyPostsViewController.myPostCellIdentifier, cellType: MyPostTableViewCell.self)) { _, item, cell in
            cell.reactor = MyPostTableViewCellReactor(post: item, serviceProvider: reactor.serviceProvider)
            cell.settingButton.rx.tap
                .bind {
                    self.coordinator?.presentEditActionSheet(reactor: reactor, post: item)
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
                guard let postCoordinator = self.coordinator?.parentCoordinator.childCoordinator[1] as? PostCoordinator else { return }
                postCoordinator.navigateCommentVC(rootNaviVC: self.coordinator?.navigationController, post: post)
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
