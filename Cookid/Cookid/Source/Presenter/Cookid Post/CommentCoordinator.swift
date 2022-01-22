//
//  CommentCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2022/01/21.
//

import UIKit
import Swinject

final class CommentCoordinator: CoordinatorType {
    var parentCoordinator: CoordinatorType?
    var childCoordinator: [CoordinatorType] = []
    var assembler: Assembler
    var navigationController: UINavigationController
    var post: Post?
    
    init(assembler: Assembler, navigationController: UINavigationController) {
        self.assembler = assembler
        self.navigationController = navigationController
    }
    
    func start() {
        guard let post = self.post else { return }
        let vc = assembler.resolver.resolve(CommentViewController.self, argument: post)!
        vc.coordinator = self
        vc.modalPresentationStyle = .overFullScreen
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishCommenting() {
        if let postCoordinator = parentCoordinator as? PostCoordinator {
            postCoordinator.childDidFinish(self)
        }
    }
    
    func presentAlertVCForDelete(comment: Comment) {
        guard let post = self.post else { return }
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

    func presentAlertVCForReport(comment: Comment) {
        guard let post = self.post else { return }
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
    
}
