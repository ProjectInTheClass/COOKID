//
//  PostDetailViewController.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/12.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import ReactorKit
import RxDataSources

class PostDetailViewController: UIViewController, View {
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(PostDetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        $0.separatorStyle = .none
    }
    
    private let postDetailHeaderView = PostDetailHeaderView()
    
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
    
    func bind(reactor: PostDetailReactor) {
        
        reactor.state
            .map { $0.post }
            .distinctUntilChanged { $0.postID == $1.postID }
            .bind(onNext: { [unowned self] post in
                self.postDetailHeaderView.updateUI(post: post)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.comments }
            .bind(to: tableView.rx.items(dataSource: reactor.dataSource))
            .disposed(by: disposeBag)
        
    }

}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return postDetailHeaderView
    }
}
