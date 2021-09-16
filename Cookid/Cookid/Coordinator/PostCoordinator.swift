//
//  PostCoordinator.swift
//  Cookid
//
//  Created by 박형석 on 2021/09/16.
//

import UIKit

class PostCoordinator: CoordinatorType {
    
    var childCoordinator: [CoordinatorType] = []
    var parentCoordinator: CoordinatorType
    var navigationController: UINavigationController?
    
    let userService: UserService
    let commentService: CommentService
    let postService: PostService
    
    init(parentCoordinator : CoordinatorType, userService: UserService, commentService: CommentService, postService: PostService) {
        self.parentCoordinator = parentCoordinator
        self.userService = userService
        self.commentService = commentService
        self.postService = postService
    }
    
    func start() -> UIViewController {
        var postMainVC = PostMainViewController.instantiate(storyboardID: "Post")
        postMainVC.bind(viewModel: PostViewModel(postService: postService, userService: userService, commentService: commentService))
        postMainVC.coordinator = self
        navigationController = UINavigationController(rootViewController: postMainVC)
        postMainVC.navigationController?.navigationBar.prefersLargeTitles = true
        postMainVC.navigationController?.navigationBar.tintColor = DefaultStyle.Color.tint
        postMainVC.navigationController?.navigationBar.barTintColor = .systemBackground
        return navigationController!
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
    
    func navigateAddPostVC(viewModel: PostViewModel) {
        var _ = AddPostViewController.instantiate(storyboardID: "Post")
        // 받아와서 올리기
    }
}
