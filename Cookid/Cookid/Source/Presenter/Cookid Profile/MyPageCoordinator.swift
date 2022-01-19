//
//  MyPageCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

final class MyPageCoordinator: CoordinatorType {
    
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
    
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateUserInfoVC(viewModel: MyPageViewModel) {
        var userInfoVC = UpdateUserInfoViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: viewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(userInfoVC, animated: true, completion: nil)
    }
    
    func presentEditActionSheet(reactor: MyPostReactor, post: Post) {
        let alertVC = UIAlertController(title: "내 포스팅 관리", message: "내 글 수정 혹은 삭제하기\n삭제시 복구가 불가능합니다.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            reactor.action.onNext(.deletePost(post))
        }
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            let addPostVC = AddPostViewController.instantiate(storyboardID: "Post")
            let reactor = AddPostReactor(mode: .edit(post), serviceProvider: self.serviceProvider)
            addPostVC.reactor = reactor
            self.navigationController?.pushViewController(addPostVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(deleteAction)
        alertVC.addAction(updateAction)
        alertVC.addAction(cancelAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
 
}
