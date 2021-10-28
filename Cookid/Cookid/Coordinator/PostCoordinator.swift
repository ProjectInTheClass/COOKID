//
//  PostCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit
import ReactorKit

class PostCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    
    let userService: UserService
    let commentService: CommentService
    let postService: PostService
    let mealService: MealService
    let shoppingService: ShoppingService
    
    init(parentCoordinator : CoordinatorType, userService: UserService, commentService: CommentService, postService: PostService, mealService: MealService, shoppingService: ShoppingService) {
        self.parentCoordinator = parentCoordinator
        self.userService = userService
        self.commentService = commentService
        self.postService = postService
        self.mealService = mealService
        self.shoppingService = shoppingService
    }
    
    func start() -> UIViewController {
        var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
        postMainVC.bind(viewModel: PostViewModel(postService: postService, userService: userService, commentService: commentService, mealService: mealService, shoppingService: shoppingService))
        postMainVC.coordinator = self
        navigationController = UINavigationController(rootViewController: postMainVC)
        navigationBarConfigure()
        return navigationController!
    }
    
    private func navigationBarConfigure() {
        navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func navigateRankingVC(viewModel: PostViewModel) {
        let rankingViewModel = RankingViewModel(userService: viewModel.userService)
        var vc = RankingMainViewController()
        vc.bind(viewModel: rankingViewModel)
        vc.modalPresentationStyle = .automatic
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateSignInVC(viewModel: PostViewModel) {
        var signInVC = SignInViewController.instantiate(storyboardID: "UserInfo")
        signInVC.bind(viewModel: viewModel)
        signInVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(signInVC, animated: true)
    }
    
    func navigateAddPostVC(viewModel: PostViewModel, senderTag: Int) {
        let addPostVC = AddPostViewController.instantiate(storyboardID: "Post")
        let reactor = AddPostReactor(postService: postService, userService: userService)
        addPostVC.reactor = reactor
        navigationController?.pushViewController(addPostVC, animated: true)
        
        switch senderTag {
        case 1:
            print("바버튼 누르기")
        case 2:
            print("글 올리기")
        case 3:
            YPImagePickerController.shared.pickingImages(viewController: addPostVC) { images in
                reactor.action.onNext(.imageUpload(images))
            }
        default:
            break
        }
    }
    
    func navigateCommentVC(rootNaviVC: UINavigationController?, post: Post) {
        var commentVC = CommentViewController()
        let viewModel = CommentViewModel(post: post, commentService: commentService, userService: userService)
        commentVC.bind(viewModel: viewModel)
        commentVC.coordinator = self
        commentVC.modalPresentationStyle = .overFullScreen
        if let rootNaviVC = rootNaviVC {
            rootNaviVC.pushViewController(commentVC, animated: true)
        } else {
            navigationController?.pushViewController(commentVC, animated: true)
        }
    }
    
    func presentAlertVCForDelete(viewModel: CommentViewModel, comment: Comment) {
        let alertVC = UIAlertController(title: "삭제하기", message: "댓글을 삭제하시겠습니까?\n한 번 삭제한 글을 복구가 불가능 합니다\n답글이 있는 경우 답글도 모두 삭제됩니다", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            viewModel.input.reportButtonTapped.onNext(comment)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
    func presentAlertVCForReport(viewModel: CommentViewModel, comment: Comment) {
        let alertVC = UIAlertController(title: "신고하기", message: "댓글을 신고하시겠습니까?\n적극적인 신고로 깨끗한 환경을 만들어 주세요:)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "신고", style: .destructive) { _ in
            viewModel.input.reportButtonTapped.onNext(comment)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
    func presentReportActionVC(reactor: PostCellReactor, post: Post, currentUser: User) {
        let alertVC = UIAlertController(title: "포스팅 관리", message: "신고나 삭제된 게시물은 복구할 수 없습니다.\n깨끗한 공유문화를 위해서 함께 해주세요!", preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
            print("신고")
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            print("삭제")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertVC.addAction(reportAction)
        if post.user.id == currentUser.id {
            alertVC.addAction(deleteAction)
        }
        alertVC.addAction(cancelAction)
        navigationController?.present(alertVC, animated: true, completion: nil)
    }
    
}
