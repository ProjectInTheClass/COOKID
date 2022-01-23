//
//  PostCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit
import ReactorKit
import Swinject

final class PostCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController
    init(assembler: Assembler,
         navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func childDidFinish(_ child: CoordinatorType) {
        for (index, coordinator) in childCoordinator.enumerated() where coordinator === child {
            childCoordinator.remove(at: index)
            break
        }
    }
    
    private func navigationBarConfigure() {
        navigationController.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateRankingVC() {
        let vc = assembler.resolver.resolve(RankingMainViewController.self)!
        vc.modalPresentationStyle = .automatic
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateSignInVC() {
        let vc = assembler.resolver.resolve(SignInViewController.self)!
        vc.modalPresentationStyle = .overFullScreen
        navigationController.present(vc, animated: true)
    }
    
    func navigateAddPostVC(mode: PostEditViewMode, senderTag: Int) {
        let reactor = assembler.resolver.resolve(AddPostReactor.self, argument: mode)!
        let vc = AddPostViewController.instantiate(storyboardID: "Post")
        vc.reactor = reactor
        navigationController.pushViewController(vc, animated: true)
        
        switch senderTag {
        case 1:
            print("바버튼 누르기")
        case 2:
            print("글 올리기")
        case 3:
            YPImagePickerManager.shared.pickingImages(viewController: vc) { images in
                reactor.action.onNext(.imageUpload(images))
            }
        default:
            break
        }
    }
    
    func navigateCommentVC(post: Post) {
        let commentCoordinator = CommentCoordinator(assembler: self.assembler, navigationController: self.navigationController)
        commentCoordinator.post = post
        commentCoordinator.parentCoordinator = self
        childCoordinator.append(commentCoordinator)
        commentCoordinator.start()
    }
    
    func presentReportActionVC(reactor: PostCellReactor) {

        let alertVC = UIAlertController(title: "포스팅 관리", message: "신고나 삭제된 게시물은 복구할 수 없습니다.\n깨끗한 공유문화를 위해서 함께 해주세요!", preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
            reactor.action.onNext(.reportButtonTapped(reactor.post))
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            reactor.action.onNext(.deleteButtonTapped(reactor.post))
        }
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.navigateAddPostVC(mode: .edit(reactor.post), senderTag: 1)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        if reactor.post.user.id == reactor.currentState.user.id {
            alertVC.addAction(deleteAction)
            alertVC.addAction(updateAction)
        } else {
            alertVC.addAction(reportAction)
        }
        alertVC.addAction(cancelAction)
        navigationController.present(alertVC, animated: true, completion: nil)
    }
    
}
