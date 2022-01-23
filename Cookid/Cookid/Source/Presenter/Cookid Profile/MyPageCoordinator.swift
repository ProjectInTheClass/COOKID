//
//  MyPageCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit
import Swinject

final class MyPageCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController?
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    func start() {
    
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
        
    }
    
    func navigateCommentVC(post: Post) {
        let commentCoordinator = CommentCoordinator(assembler: self.assembler)
        commentCoordinator.navigationController = self.navigationController
        commentCoordinator.post = post
        commentCoordinator.parentCoordinator = self
        childCoordinator.append(commentCoordinator)
        commentCoordinator.start()
    }
    
    func navigateAddMealVC(mode: MealEditMode) {
        let vc = AddMealViewController.instantiate(storyboardID: "Main")
        vc.reactor = assembler.resolver.resolve(AddMealReactor.self, argument: mode)!
        vc.coordinator = nil
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = .clear
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func navigateUserInfoVC() {
        let viewModel = assembler.resolver.resolve(MyPageViewModel.self)!
        var userInfoVC = UpdateUserInfoViewController.instantiate(storyboardID: "UserInfo")
        userInfoVC.bind(viewModel: viewModel)
        userInfoVC.modalPresentationStyle = .custom
        userInfoVC.modalTransitionStyle = .crossDissolve
        navigationController?.present(userInfoVC, animated: true, completion: nil)
    }
    
    func presentEditActionSheet(post: Post) {
        let alertVC = UIAlertController(title: "내 포스팅 관리", message: "내 글 수정 혹은 삭제하기\n삭제시 복구가 불가능합니다.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            let reactor = self.assembler.resolver.resolve(MyPostReactor.self)!
            reactor.action.onNext(.deletePost(post))
        }
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            let addPostVC = AddPostViewController.instantiate(storyboardID: "Post")
            let reactor = self.assembler.resolver.resolve(AddPostReactor.self, argument: PostEditViewMode.edit(post))!
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
