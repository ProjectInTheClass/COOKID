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
        let vc = assembler.resolver.resolve(CommentViewController.self, argument: post)!
        vc.coordinator = self
        vc.modalPresentationStyle = .overFullScreen
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentAlertVCForDelete(post: Post, comment: Comment) {
        let viewModel = assembler.resolver.resolve(CommentViewModel.self, argument: post)!
        let alertVC = UIAlertController(title: "삭제하기", message: "댓글을 삭제하시겠습니까?\n한 번 삭제한 글을 복구가 불가능 합니다\n답글이 있는 경우 답글도 모두 삭제됩니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            viewModel.input.deleteButtonTapped.onNext(comment)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        navigationController.present(alertVC, animated: true, completion: nil)
    }

    func presentAlertVCForReport(post: Post, comment: Comment) {
        let viewModel = assembler.resolver.resolve(CommentViewModel.self, argument: post)!
        let alertVC = UIAlertController(title: "신고하기", message: "댓글을 신고하시겠습니까?\n적극적인 신고로 깨끗한 환경을 만들어 주세요:)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "신고", style: .destructive) { _ in
            viewModel.input.reportButtonTapped.onNext(comment)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        navigationController.present(alertVC, animated: true, completion: nil)
    }

    func presentReportActionVC(sender: UIViewController?, post: Post, currentUser: User) {
        
        let reactor = assembler.resolver.resolve(PostCellReactor.self, arguments: post, sender)!
        let alertVC = UIAlertController(title: "포스팅 관리", message: "신고나 삭제된 게시물은 복구할 수 없습니다.\n깨끗한 공유문화를 위해서 함께 해주세요!", preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
            reactor.action.onNext(.reportButtonTapped(post))
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            reactor.action.onNext(.deleteButtonTapped(post))
        }
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.navigateAddPostVC(mode: .edit(post), senderTag: 1)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        if post.user.id == currentUser.id {
            alertVC.addAction(deleteAction)
            alertVC.addAction(updateAction)
        } else {
            alertVC.addAction(reportAction)
        }
        alertVC.addAction(cancelAction)
        navigationController.present(alertVC, animated: true, completion: nil)
    }
}




